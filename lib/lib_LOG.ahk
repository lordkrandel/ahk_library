class Log {

    code := { warn:  "W" , info:  "I" , error: "E" }

    files := []
    obj   := []

    __new( f ){
        this.files := f
    }

    write( in, kind = "info"){

        ; Save the time informations
        FormatTime, time, %A_Now%, yyyy/MM/dd hh:mm:ss

        ; Compose the log message
        s := "[%s] [%s] %s".fmt( time, Log.code[kind], in )

        ; If there is a file, append the logstring
        for idx, filename in this.files {
            if (filename == "*"){
                fileAppend, % s "`n", *
            } else {
                fileAppend, % s "`n", % filename
            }
        }

        ; Also add to internal object
        obj.insert( s )

    }

    ; To actually see the Stdout, add " | more " to the script's commandline
    addStdout(){
        this.files.insert("*")
        return 1
    }

    addFile(f){
        this.files.insert(f)
        return f
    }

    clear(){
        this.obj := {}
    }

    warn(s, f = ""){
        Log.write(s, "warn", f)
    }
    info(s, f = ""){
        Log.write(s, "info", f)
    }
    error(s, f = ""){
        Log.write(s, "error", f)
        ExitApp
    }

}

