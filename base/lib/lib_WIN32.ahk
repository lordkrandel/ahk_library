#include <lib_CORE>

;; Windows OS static handler class
Class Win32 extends ObjectBase {

    ;; Numput wrapper
    put(a_value, a_type="", a_address=0, a_offset=0){

        ; saving last address is useful for chaining
        if ( a_address ){
            l_address := a_address
        } 
        if ( a_offset ) {
            l_address += a_offset
        }
        l_address := Numput( a_value, l_address+0, 0, a_type )
    }
 
    ;; 20141231 Get last formatted error
    GetError(){
        return Win32Functions.GetLastFormattedError()
    }
 
    ;; Call DLLcall when function is not found
    __call(a_name, a_params*){
        l_func := Win32[a_name]
        if !(l_func && isfunc(l_func)){
            return DllCall(a_name, a_params*)
        }
        return l_func.(Win32, a_params*)
    }

}

class Win32Functions extends ObjectBase {

    ;; FormatMessage
    FormatMessage(a_message_id="") {
        if !(a_message_id) {
            a_message_id := A_lasterror
        }
        VarSetCapacity(l_message, 2024)
        Win32.FormatMessageW( ""
            . "UInt", 0x1000
            , "UInt", 0
            , "UInt", a_message_id
            , "UInt", 0x800
            , "Ptr",  &l_message
            , "UInt", 500
            , "UInt", 0)
        return "(%d) %s".fmt(a_message_id, l_message)
    }
    
    ;; Getlasterror + Formatmessage
    GetLastFormattedError() {
        return Win32Functions.FormatMessage()
    }    

}

;; Win32Constants class gets merged against Win32
class Win32Constants {
    static FD_READ                       := 0x1
    static FD_CLOSE                      := 0x20
    static IPPROTO_TCP                   := 6
    static AF_INET                       := 2
    static SOCK_STREAM                   := 1
    static AI_PASSIVE                    := 1
    static WSA_WOULDBLOCK                := 10035
    static WSA_CONNRESET                 := 10054
    static FORMAT_MESSAGE_FROM_SYSTEM    := 0x1000
    static FORMAT_MESSAGE_IGNORE_INSERTS := 0x200
    static LANG_SYSTEM_DEFAULT           := 0x800
    static LANG_USER_DEFAULT             := 0x400
    static INADDR_NONE                   := 0xffffffff
    static MSG_WAITALL                   := 0x8
    static LB_SETTOPINDEX                := 0x197
    static LB_GETCURSEL                  := 0x188
    static LB_SETSEL                     := 0x185

    ; CreateTimerQueueTimer
    ; http://msdn.microsoft.com/en-us/library/windows/desktop/ms682485%28v=vs.85%29.aspx
    static WT_EXECUTEDEFAULT             := 0x00000000
    static WT_EXECUTEINTIMERTHREAD       := 0x00000020
    static WT_EXECUTEINIOTHREAD          := 0x00000001
    static WT_EXECUTEINPERSISTENTTHREAD  := 0x00000080
    static WT_EXECUTELONGFUNCTION        := 0x00000010
    static WT_EXECUTEONLYONCE            := 0x00000008
    static WT_TRANSFER_IMPERSONATION     := 0x00000100
    static INFINITE                      := 0xFFFFFFFF
    static SYNCHRONIZE                   := 0x00100000
}

