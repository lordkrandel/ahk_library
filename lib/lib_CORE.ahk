#include <lib_STRING>
#include <lib_MATH>
#include <lib_OBJ>
#include <lib_CALLBACK>
#include <lib_FILE>
#include <lib_JSON>
#include <lib_LOG>
#include <lib_TRAYTIP>
#include <lib_WIN32>
#include <lib_ODBC>
#include <lib_SOCKET>
#include <lib_EVENTDISPATCHER>
#include <lib_WINDOW>
#include <lib_G>
#include <lib_CONTROL>
#include <lib_LISTBOX>

; Universal basic functions that should be accessible anywhere
class Core {

    init(){
        String := new String()
        Win32  := new Win32()
    }

    ; Returns the first non null/zero element in the arguments
    firstValid( a* ){
        for k,v in a {
            if (v){
                return v
            }
        }
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
}

Core.init()

