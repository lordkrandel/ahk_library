;; Handles log operations on different channels:
;; textfile, stdout, in-memory object
class Log {

    code  := { warn:  "W" , info:  "I" , error: "E", debug: "D" }
    files := []
    obj   := []

    ;; Constructor
    ;; 20141123 now also works as a variadic constructor
    ;; example: new Log("file1.log", "file2.log")
    ;; old:     new Log(["file1.log", "file2.log"])
    __new( a_files* ){

        if isobject(a_files){
            this.files := a_files
        } else {
            this.files := [ a_files* ]
        }

    }

    ;; Write the passed string through all registered channels
    write( in, kind = "info"){

        ; Save the time informations
        FormatTime, time, %A_Now%, yyyy/MM/dd hh:mm:ss

        ; New start/stop indicator
        if (kind == "start") {
            l_pad := ">>"
            kind := "debug"
        } else if (kind == "stop") {
            l_pad := "<<"
            kind := "debug"
        } else {
            l_pad := "  "
        }

        ; Compose the log message
        ; 20141123 Added a small padding
        s := "%s  %s  %s%s".fmt( time, Log.code[kind], l_pad, in )

        ; If there is a file, append the logstring
        for idx, filename in this.files {
            if (filename == "*"){
                fileAppend, % s "`n", *, UTF-8
            } else {
                fileAppend, % s "`n", % filename, UTF-8
            }
        }

        ; Also add to in-memory object
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
    ; 20141123 new debug tag
    debug(s, f = ""){
        Log.write(s, "debug", f)
    }

    ; 20141123 New start indicator, to show in the log where the application starts
    start(f = ""){
        Log.write(s, "start", f)
    }

    ; 20141123 New stop indicator, to show in the log where the application ends
    stop(f = ""){
        Log.write(s, "stop", f)
    }
    
}

