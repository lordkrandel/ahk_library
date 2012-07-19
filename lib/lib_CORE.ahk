#EscapeChar \
#CommentFlag //
#NoEnv

#InstallKeybdHook
#SingleInstance force
#HotkeyInterval 100

SendMode Input
SetTitleMatchMode, 2

#include lib\\lib_STRING.ahk
#include lib\\lib_MATH.ahk

class Core {
    swap(arr){
        if (isobject(arr)){
            o := {}
            for k,v in arr {
                o.insert(v,k)
            }
            return o
        }
    }
    firstValid( a* ){
        if (isobject(arr)){
            for k,v in a {
                if (!!v){
                    return v
                }
            }
        }
    }
    find( arr, val ){
        if (isobject(arr)){
            for k, v in arr {
                if ( v == val ){
                    return A_index
                }
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
    keys(arr){
        if (isobject(arr)){
            o := {}
            for k, v in arr {
                o.insert(k)
            }
            return o
        }
    }
}



