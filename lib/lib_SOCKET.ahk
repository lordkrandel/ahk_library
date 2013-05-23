; SocketAddress
class SocketAddress {

    size := 16

    ; constructor
    __new( host="127.0.0.1", port = 18864 ){
        this.host   := host
        this.port   := port
        this.__port := this.w32_htons()
        this.__host := this.w32_inet_addr( host )
    }

    ; return as a struct
    getStruct(){
        sockAddr := Core.alloc( this.size )

        Win32.put( Win32.AF_INET, "Short", &sockAddr )
        Win32.put( this.__port,   "UShort")
        Win32.put( this.__host )

        return sockAddr
    }

    ; htons win32 wrapping
    w32_htons(){
        DllCall("Ws2_32\htons", port)
        return port
    }

    ; inet_addr win32 wrapping
    w32_inet_addr( host ) {

        ; convert the address to ANSI
        hostTemp := Core.alloc( this.size )
        StrPut( host, &hostTemp, "cp0" )

        ; use inet_addr to build the structure
        ret := Core.alloc( this.size )
        ret := DllCall("Ws2_32\inet_addr", hostTemp)

        return ret
    }


}

; Socket
class Socket {

    settings := {}

    ;constructor
    __new( host, port ){

        this.addr := new SocketAddress(host, port)

        data := Core.alloc( 32 )
        DllCall("ws2_32\WSAStartup", 2, &data )
        if ( ErrorLevel || ! data ) {
            throw this.error("Cannot initialize WinSock")
        }
        this.connect()

    }

    ; connect
    connect(){

        this.socket := Win32.call("Ws2_32\socket", Win32.AF_INET, Win32.SOCK_STREAM, Win32.IPPROTO_TCP )
        if ( this.socket <= 0){
            throw this.error("Error creating socket")
        }

        a := this.addr.getStruct()

        ret := Win32.call("Ws2_32\connect", this.socket, &a, this.addr.size )
        if ( ret < 0 ){
            throw this.error("Error connecting socket")
        }
        return ret

    }

    ; send 
    send( data ) {
        ret := Win32.call("ws2_32\send", this.socket, data, 2 * ( strlen(data) + 1 ), 0 )
        if (ret < 0){
            throw this.error("Error sending data")
        }
    }

    ; event ( should be virtual )
    event(buf){
        Msgbox, % buf
    }

    ; receive
    receive(size = 8192 ){

        Loop,
        {
            buf := Core.alloc( 8192 )
            buflen := DllCall("Ws2_32\recv", this.socket, &buf, size, 0 )

            if( buflen <= 0 ){
                err := DllCall("Ws2_32\GetLastError")

;               ONLY FOR NON-BLOCKING
;               if ( err == Win32.WSA_WOULDBLOCK ){
;                   buf := ""
;                   break
;               }

                if ( buflen == 0 ){
                    continue
                } else if (err == Win32.WSA_CONNRESET){
                    break
                } else {
                    throw this.error("Error receiving data")
                }

            } else {
                this.event(buf)
                break
            }
        }
    }

    ; close
    close(){
        ret := DllCall("ws2_32\closesocket", this.handle)
        if (!ret){
            throw this.error("Cannot close socket!")
        }
    }

    ; error
    error(s){
        return % s "`n" "error:" this.getLastError() "`n" "handle: " this.handle
    }

    ; getlasterror
    getLastError( size=8192 ){
        err := DllCall("Ws2_32\WSAGetLastError")
        if (!err){
            return err
        }
        txt := Core.alloc( size, 32 )
        ret := DllCall("FormatMessage", Win32.FORMAT_MESSAGE_FROM_SYSTEM, 0, err, Win32.LANG_USER_DEFAULT, &txt, size, 0 )
        return ( ret >= 0 ? err ", " txt : err)
    }

    ; delete
    __delete(){
        DllCall("ws2_32\WSACleanup")
    }

    ;set async
    setAsync( msg = 0x5000 ) {
        ret := DllCall("ws2_32\WSAAsyncSelect", this.socket, A_ScriptHwnd, msg, Win32.FD_READ + Win32.FD_CLOSE )
        if (!ret){
            throw this.error("Cannot set socket Asynchronous")
        }
    }

}
