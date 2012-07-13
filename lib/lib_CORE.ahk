#EscapeChar \
#CommentFlag //

#InstallKeybdHook
#SingleInstance force
#HotkeyInterval 100

SendMode Input
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, images\\Autokube.ico

#include lib\\lib_STRING.ahk
#include lib\\lib_MATH.ahk

class Core {
    firstValid( a* ){
        for k,v in a {
            if (!!v){
                return v
            }
        }
        return ""
    }
    find( arr, val ){
        for k, v in arr {
            if ( v == val ){
                return A_index
            }
        }
    }
    cpu(){
        // First call starts, second call stops and gives result
        static count := 0
        t := Core.firstValid(count)
        DllCall("QueryPerformanceCounter", "Int64*", count)
        if (t){
            delta := count - t
            count := 0
            return delta
        }
    }
}



