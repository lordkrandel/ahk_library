; Win32 API class
Class Win32 {

    __new(){
        #include <lib_WIN32_constants>
        #include <lib_WIN32_functions>
        #include <lib_WIN32_types>
    }

    __call(aname, byRef params*){
        if ( isfunc( Win32[aname]) ){
            return Win32[aname].(this, params*)
        }

        callParams := []
        for k, v in params {
            type := Win32.functions[aname][k]
            callParams.insert(type)
            
            VarSetCapacity(params[k], Win32.getSize(type), 0)
            callParams.insert(params[k])
        }
        v := Win32.functions[aname][k+1]
        if ( v ){
            callParams.insert(v)
        }
        return DllCall(aname, callParams*)
    }

    getLen(type){
        return Win32.types[type].size
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


