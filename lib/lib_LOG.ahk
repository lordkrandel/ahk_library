#include lib_CORE.ahk

class Log {

    code := { warn:  "W"
            , info:  "I"
            , error: "E" }

    write( s, kind = "info", f = "" ){
        static file := Core.firstValid(f, file, "log\" regexreplace(A_scriptname, ".ahk", "") ".log" )
        FormatTime, time, %A_Now%, MM/dd hh:mm:ss
        s := time "`t" Log.code[kind] "`t" s
        FileAppend, % s, % file
    }

    warn(s, f = ""){
        Log.write(s, "warn", f)
    }
    info(s, f = ""){
        Log.write(s, "info", f)
    }
    error(s, f = ""){
        Log.write(s, "error", f)
    }

}

