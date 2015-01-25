;; Handles log operations on different channels:
;; textfile, stdout, in-memory object
class Log extends ObjectBase {

    code  := { warn: "W" , info: "I" , error: "E", debug: "D" }
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
            this.files := [a_files*]
        }
    }

    ;; Write the passed string through all registered channels
    write( a_s, a_kind = "info" ){

        ; Save the time informations
        FormatTime, l_time, %A_Now%, yyyy/MM/dd HH:mm:ss

        ; New start/stop indicator
        if (a_kind == "start") {
            l_pad  := ">>"
            a_kind := "debug"
        } else if (a_kind == "stop") {
            l_pad  := "<<"
            a_kind := "debug"
        } else {
            l_pad := "  "
        }

        ; Compose the log message
        ; 20141123 Added a small padding
        l_s := "%s  %s  %s%s".fmt( l_time, Log.code[a_kind], l_pad, a_s )

        ; If there is a file, append the logstring
        for _, l_filename in this.files {
            if (l_filename == "*"){
                fileAppend, % l_s "`n", * ;, % "UTF-8"
            } else {
                fileAppend, % l_s "`n", % l_filename, % "UTF-8"
            }
        }

        ; Also add to in-memory object
        this.obj.insert( l_s )

    }

    ; To actually see the Stdout, add " | more " to the script's commandline
    addStdout(){
        this.files.insert("*")
        return 1
    }
    addFile(a_file){
        this.files.insert(a_file)
        return a_file
    }
    clear(){
        this.obj := {}
    }

    warn(a_s){
        Log.write(a_s, "warn")
    }
    info(a_s){
        Log.write(a_s, "info")
    }
    error(a_s){
        Log.write(a_s, "error")
        ExitApp
    }
    ; 20141123 new debug tag
    debug(a_s){
        Log.write(a_s, "debug")
    }

    ; 20141123 New start indicator, to show in the log where the application starts
    start(){
        Log.write("", "start")
    }

    ; 20141123 New stop indicator, to show in the log where the application ends
    stop(){
        Log.write("", "stop")
    }
    
}

