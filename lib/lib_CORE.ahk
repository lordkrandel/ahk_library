
;; Base class for all variables
class VarBase {
}

; Assign VarBase as a base class for all variables
"".base.base := VarBase

; includes
#include <lib_STRING> 
#include <lib_OBJ>
#include <lib_FILE>            ; tests
#include <lib_MATH>            ; tests
#include <lib_LOG>             ; tests
#include <lib_WINDOW>          ; tests
#include <lib_CALLBACK>        ; tests
#include <lib_ODBC>            ; test Query
#include <lib_EVENTDISPATCHER> ; tests
#include <lib_CLIP>            ; tests
#include <lib_TRAYTIP>
#include <lib_CONTROL>         ; tests
#include <lib_LISTBOX>         ; tests
#include <lib_SOCKET>          ; tests
#include <lib_WIN32>           ; tests
#include <lib_G>               ; tests
#include <lib_G_SINGLESELECT>  ; tests
#include <lib_CONTROL>         ; tests
#include <lib_JSON>
;#include <lib_TEST>

;; Universal basic functions that should be accessible anywhere
class Core {

    ; Returns the range array
    range(min, max, step=1){
        arr := []
        while (min <= max) {
            arr.insert(min)
            min := min + step
        }
        return arr
    }
    
    ; Timer function. First call starts, second call stops and returns the delta
    cpu(){
        static count := 0
        t := Core.firstValid(count)
        p := Core.alloc( 8, 0 )
        Win32.QueryPerformanceCounter( &p )
        count := numget(p, 0, "Int64")
        if (t) {
            delta := count - t
            count := 0
            return delta
        }
    }

    ; return a variable with "n" bytes reserved
    alloc( n, fillbyte=""){
        v := ""
        VarSetCapacity( v, n, fillbyte )
        return v
    }

    ; Merge all methods and properties from source classes to destination class
    mixin(a_dest, a_parms*){
        return Core.merge(a_dest.base.base, a_parms*)
    }

    ; Merge all methods and properties from source objects to destination object
    merge(a_dest, a_parms*){
        for _, l_source in a_parms {
            for k, v in l_source {
                if (k == "__Class"){
                    continue
                }
                a_dest[k] := v
            }

        }
        return a_dest
    }
    
    toggleMaxSpeed(){
        static backup := ""
        if (A_BatchLines == -1){
            setbatchlines, % backup
        } else {
            backup := A_BatchLines
            setbatchlines, % -1
        }
    }
}

