#NoEnv

#InstallKeybdHook
#SingleInstance force
#HotkeyInterval 100

SendMode Input
SetTitleMatchMode, 2

#include lib_STRING.ahk
#include lib_MATH.ahk

; Universal basic functions that should be accessible anywhere
class Core {

    ; Returns an object with keys and values swapped
    swap(arr){
        if (isobject(arr)){
            o := {}
            for k,v in arr {
                o.insert(v,k)
            }
            return o
        }
    }

    ; Returns the first non null/zero element in the arguments
    firstValid( a* ){
        for k,v in a {
            if (!!v){
                return v
            }
        }
    }

    ; Returns the (first) position of an element in an array or object
    in( arr, val ){
        if (isobject(arr)){
            for k, v in arr {
                if ( v == val ){
                    return A_index
                }
            }
        }
    }

    ; Timer function. First call starts, second call stops and returns the delta
    cpu(){
        static count := 0
        t := Core.firstValid(count)
        DllCall("QueryPerformanceCounter", "Int64*", count)
        if (t){
            delta := count - t
            count := 0
            return delta
        }
    }

    ; Returns all the keys of an object
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



