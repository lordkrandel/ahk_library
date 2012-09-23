#include <lib_CORE>
#include <lib_STRING>

; Win32 API class
Class Win32 {

    __new(){
        #include <lib_WIN32_constants>
        #include <lib_WIN32_functions>
        #include <lib_WIN32_types>
    }

    __call(aname, params*){
        callParams := []
        for k, v in params {
            callParams.insert(Win32.functions[aname][k])
            callParams.insert(params[k])
        }
        v := Win32.functions[aname][k+1]
        if ( v ){
            callParams.insert(v)
        }
        return DllCall(aname, callParams*)
    }

    ; get the type size
    getSize(type){
        return Win32.typesLength[type.toLower()]
    }

    ; for chained numputs
    put(val, type = "", addr = 0){
        static a = 0
        if ( addr ){
            a := addr
        }
        a := Numput( val, a+0, 0, type )
    }
}


