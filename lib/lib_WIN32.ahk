#include lib_CORE.ahk
#include lib_FILE.ahk
#include lib_STRING.ahk

; static global class
Win32.init()

; Win32 API static class
Class Win32 {

    init(){
        #include lib_WIN32_constants.ahk
        #include lib_WIN32_functions.ahk
        #include lib_WIN32_types.ahk
    }

    ; Call test
    call(aname, params*){
        callParams := []
        for k, v in Win32.functions[aname] {
            callParams.insert(trim(v))
            callParams.insert(params[k])
        }
        v := Win32.functions[aname][k+1]
        ; if ( v ){
        ;     callParams.insert(v)
        ; }
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


