#include <lib_STRING>
#include <lib_OBJ>
#include <lib_FILE>
#include <lib_MATH>
#include <lib_LOG>
#include <lib_WINDOW>
#include <lib_CALLBACK>
#include <lib_ODBC>
#include <lib_QUERY>
#include <lib_EVENTDISPATCHER>
#include <lib_CLIP>
#include <lib_TRAYTIP>
#include <lib_CONTROL>
#include <lib_LISTBOX>
#include <lib_SOCKET>
#include <lib_WIN32>
#include <lib_G>
#include <lib_G_SINGLESELECT>
#include <lib_CONTROL>
#include <lib_JSON>
#include <lib_SQLFORMATTER>
#include <lib_XCOPY>

;; Base class for all variables
class VarBase {
}

;; Universal basic functions that should be in a global scope
class Core extends ObjectBase {

    ;; Guard against double initialization
    static init_done := ""

    ;; Initialize the environment
    init(){
        global

        #NoEnv
        SetWorkingDir %A_ScriptDir%
        Sendmode, Input

        if (Core.init_done){
            return
        }
        Core.init_done := 1
        
        ; Assign VarBase as a base class for all variables
        "".base.base := VarBase
        Core.merge(VarBase, String)
        Core.mixin(VarBase, StringAsPathMixin)
        Core.mixin(VarBase, StringAsMathMixin)

        Win32 := new Win32()
        Win32Functions := new Win32Functions()
        TrayTip := new Traytip()
        Clip := new Clip()
        Core.merge(Win32, Win32Constants)
        JSON := new JSON()

        ; Get home variable
        EnvGet, l_home, HOME
        Core.home := l_home

    }

    ;; Returns the range array
    range(min, max, step=1){
        arr := []
        while (min <= max) {
            arr.insert(min)
            min := min + step
        }
        return arr
    }
    
    ;; Timer function. First call starts, second call stops and returns the delta
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

    ;; return a variable with "n" bytes reserved
    alloc( n, fillbyte=""){
        v := ""
        VarSetCapacity( v, n, fillbyte )
        return v
    }

    ;; Merge all methods and properties from source classes to destination class
    mixin(a_dest, a_parms*){
        return Core.merge(a_dest.base.base, a_parms*)
    }

    ;; Merge all methods and properties from source objects to destination object
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
    
    ;; Toggle maximum execution speed
    toggleMaxSpeed(){
        static backup := ""
        if (A_BatchLines == -1){
            setbatchlines, % backup
        } else {
            backup := A_BatchLines
            setbatchlines, % -1
        }
    }
    
    ;; 20141231 Get a variable value from quoted name
    fromQuotedName(a_quotedname){
        l_split := a_quotedname.split(".")
        for k, v in l_split {
            if (k == 1){
                l_current := %v%
            } else {
                l_current := l_current[v]
            }				
        }
        return l_current
    }
    
}
