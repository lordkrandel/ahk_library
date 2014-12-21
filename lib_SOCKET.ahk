#include <LIB_CORE>

;; SocketAddress data structure
class SocketAddress extends ObjectBase {

    size := 16

    ;; constructor
    __new( a_host="127.0.0.1", a_port=7007 ){
        this.host   := a_host
        this.port   := a_port
        this.__port := this.w32_htons()
        this.__host := this.w32_inet_addr( a_host )
    }

    ;; return as a struct
    getStruct(){
        l_struct := Core.alloc( this.size )

        Win32.put( Win32.AF_INET, "Short", &l_struct )
        Win32.put( this.__port,   "UShort")
        Win32.put( this.__host )

        return l_struct
    }

    ;; Win32 Wrap htons 
    w32_htons(){
        DllCall("Ws2_32\htons", l_port)
        return l_port
    }

    ;; Win32 Wrap inet_addr 
    w32_inet_addr( a_host ) {

        ;; convert the address to ANSI
        l_hostTemp := Core.alloc( this.size )
        StrPut( a_host, &l_hostTemp, "cp0" )

        ; use inet_addr to build the structure
        l_ret := Core.alloc( this.size )
        l_ret := DllCall("Ws2_32\inet_addr", l_hostTemp)

        return l_ret
    }


}

;; Socket class
class Socket extends ObjectBase {

    settings := {}

    ;; Constructor
    __new( a_host, a_port ){

        this.addr := new SocketAddress(a_host, a_port)

        l_ret := Core.alloc( 32 )
        DllCall("ws2_32\WSAStartup", 2, &l_ret )
        if ( ErrorLevel || ! l_ret) {
            throw Exception(this.errormessage("Cannot initialize WinSock"))
        }

        this.connect()

    }

    ;; Destructor
    __delete(){
        DllCall("ws2_32\WSACleanup")
    }

    ;; Connect the socket
    connect(){

        this.socket := Win32.call("Ws2_32\socket", Win32.AF_INET, Win32.SOCK_STREAM, Win32.IPPROTO_TCP )
        if ( this.socket <= 0){
            throw Exception(this.errormessage("Error creating socket"))
        }

        l_struct := this.addr.getStruct()
        l_ret := Win32.call("Ws2_32\connect", this.socket, &l_struct, this.addr.size )
        if ( l_ret < 0 ){
            throw Exception(this.errormessage("Error connecting socket"))
        }

        return l_ret

    }

    ;; Send arbitrary data through the socket 
    send( a_data ) {
        l_ret := Win32.call("ws2_32\send", this.socket, a_data, 2 * ( strlen(a_data) + 1 ), 0 )
        if (l_ret < 0){
            throw Exception(this.errormessage("Error sending data"))
        }
    }

    ;; event ( consider it virtual )
    event(a_buffer){
    }

    ;; Receive data from the socket
    receive( a_size = 8192 ){

        Loop,
        {
            l_buffer := Core.alloc( 8192 )
            l_buffer_len := DllCall("Ws2_32\recv", this.socket, &l_buffer, a_size, 0 )

            if( l_buffer_len <= 0 ){
;               ONLY FOR NON-BLOCKING
;               if ( err == Win32.WSA_WOULDBLOCK ){
;                   buf := ""
;                   break
;               }

;                if ( buflen == 0 ){
;                    continue
;                } else 
                l_error := DllCall("Ws2_32\GetLastError")
                if (l_error == Win32.WSA_CONNRESET){
                    break
                } else {
                    throw Exception(this.errormessage("Error receiving data"))
                }

            } else {
                this.event(l_buffer)
                break
            }
        }
    }

    ;; Close the socket
    close(){
        l_ret := DllCall("ws2_32\closesocket", this.handle)
        if (!l_ret){
            throw Exception(this.errormessage("Cannot close socket!"))
        }
    }

    ;; Returns a customized exception message
    errormessage(a_text){
        return Exception(a_text "`n" "error:" this.getLastError() "`n" "handle: " this.handle)
    }

    ;; Win32 Wrap getLastError
    getLastError( a_size=8192 ){
        l_err := DllCall("Ws2_32\WSAGetLastError")
        if !(l_err){
            return l_err
        }
        l_text := Core.alloc( a_size, 32 )
        l_ret := DllCall("FormatMessage", Win32.FORMAT_MESSAGE_FROM_SYSTEM, 0, l_err, Win32.LANG_USER_DEFAULT, &l_text, a_size, 0 )
        l_ret := ( l_ret >= 0 ? l_err ", " l_text : l_err)
        return l_ret
    }

    ;; Set async socket
    setAsync( a_message_id=0x5000 ) {
        l_ret := DllCall("ws2_32\WSAAsyncSelect", this.socket, A_ScriptHwnd, a_message_id, Win32.FD_READ + Win32.FD_CLOSE )
        if !(l_ret){
            throw Exception(this.errormessage("Cannot set socket Asynchronous"))
        }
    }

}
