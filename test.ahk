#include <lib_WIN32>

;Win32.MessageBoxW(0, "a", Win32.FD_CLOSE.replace("3", "x"), 0)

s := new Socket("127.0.0.1", 18664)
s.send("hi!")
s.receive()
ExitApp

class SocketAddress {

    size   := 16

    __new( host="127.0.0.1", port = 18864 ){

        this.host   := host
        this.port   := port
        this.__port := Win32.call("Ws2_32\htons", port)

        ; convert the address to ANSI
        VarSetCapacity( hostTemp, 16 )
        StrPut( host, &hostTemp, "cp0" )

        ; use inet_addr to build the structure
        VarSetCapacity( this.__host, 16 )
        this.__host := Win32.call("Ws2_32\inet_addr", hostTemp)

    }

    getStruct(){
        sockAddr   := 0
        VarSetCapacity(sockAddr, this.size)

        ; chained NumPuts
        Win32.put( Win32.AF_INET, "Short", &sockAddr )
        Win32.put( this.__port,   "UShort")
        Win32.put( this.__host )

        return sockAddr
    }

}
class Socket {


    settings := {}

    __new( host, port ){

        this.addr := new SocketAddress(host, port)

        Varsetcapacity(data, 32)
        Win32.call("ws2_32\WSAStartup", 2, &data )
        if ( ErrorLevel || ! data ) {
            throw this.error("Cannot initialize WinSock")
        }
        this.connect()

    }

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

    send( data ) {
        ret := Win32.call("ws2_32\send", this.socket, data, 2 * ( strlen(data) + 1 ), 0 )
        if (ret < 0){
            throw this.error("Error sending data")
        }
    }

    event(buf){
        Msgbox, % buf
    }

    receive(size = 8192){

        buf := ""
        Loop,
        {
            VarSetCapacity(buf, 8192)
            buflen := Win32.call("Ws2_32\recv", this.socket, &buf, size, 0 )

            if( buflen <= 0){
                err := Win32.call("Ws2_32\GetLastError")

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


    close(){
        if ( ! ( ret := Win32.call("ws2_32\closesocket", this.handle) ) ){
            throw this.error("Cannot close socket!")
        }
    }
    error(s){
        return % s "`n" "error:" this.getLastError() "`n" "handle: " this.handle
    }
    getLastError( size=8192){
        err := Win32.call("Ws2_32\WSAGetLastError")
        if (!err){
            return
        }
        VarSetCapacity(txt, size, 32)
        ret := Win32.call("FormatMessage", Win32.FORMAT_MESSAGE_FROM_SYSTEM, 0, err, Win32.LANG_USER_DEFAULT, &txt, size, 0 )
        return ( ret >= 0 ? err ", " txt : err)
    }

    __delete(){
        Win32.call("ws2_32\WSACleanup")
    }

    setAsync( msg = 0x5000 ) {
        ret := Win32.call("ws2_32\WSAAsyncSelect", this.socket, A_ScriptHwnd, msg, Win32.FD_READ + Win32.FD_CLOSE )
        if (!ret){
            throw this.error("Cannot set socket Asynchronous")
        }
        return ret
    }

}
/*

# lib_socket.ahk test
import socket, time

host    = '127.0.0.1'
port    = 18664
backlog = 5
size    = 1024
s       = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
# s.setblocking(True)
s.bind( (host,port) )
s.listen(backlog)

client, address = s.accept()
while 1:
    data = client.recv(size)
    if data:
        # AHK_L Unicode
        print(data.decode('utf-16LE'))
        time.sleep(1)
        client.send(data)

#client.close()
*/
