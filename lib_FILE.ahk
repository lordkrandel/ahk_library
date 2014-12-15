#include <LIB_CORE>

;; File object wrapper
class File {

    ;; create the file Object
    __new(a_parms*){
        this._fileobject := fileOpen(a_parms*)
    }

    ;; wrap all file Object properties
    __get(a_name){
        if (!File[a_name]){
            return this._fileobject[a_name]
        }
    }

    ;; forward all file Object function calls
    __call(a_name, a_params*){
        if (!File[a_name]){
            return this._fileobject[a_name].(a_params*)
        }
    }
    
}

;; handles standard input as a file object
class StdIn extends File {

    ;; Constructor
    __New(){
        this._fileobject := FileOpen(DllCall("GetStdHandle", "int", -10, "ptr"), "h `n")
    }

}

;; handles standard output as a file object
class StdOut extends File {

    ;; Constructor
    __new(){
        this._fileobject := FileOpen(DllCall("GetStdHandle", "int", -11, "ptr"), "h `n")
    }
}

;; Handles any string as a potential filepath
class StringAsPathMixin {

    ;; returns the filename without the extension
    noextension(){
        SplitPath, this,,,, l_noext
        return l_noext
    }

    ;; returns the file's extension
    extension(){
        SplitPath, this,,, l_extension
        return l_extension
    }

    ;; returns the file's base path
    basepath(){
        SplitPath, this,, l_path
        return l_path   
    }

    ;; returns the file's basename 
    basename(){
        SplitPath, this, l_name
        return l_name
    }

    ;; returns the file's last modification time
    mtime(){
        FileGetTime, l_mtime, % this, M
        return l_mtime
    }

    ;; returns the file's creation time
    ctime(){
        FileGetTime, l_ctime, % this, C
        return l_ctime
    }

    ;; returns the file's last access time
    atime(){
        FileGetTime, l_atime, % this, A
        return l_atime
    }

    ;; returns an array with all the files in the pattern
    getfiles(){
        l_obj := []
        loop, %this%
        {
            l_obj.insert(a_loopfilefullpath)
        }
        return l_obj
    }

    ;; returns 1 if the filepath contains any file
    hasfiles(){
        loop, %this%
        {
            return 1
        }
        return 0
    }

}



