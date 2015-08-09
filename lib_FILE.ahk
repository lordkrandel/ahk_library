#include <LIB_CORE>

;; File object wrapper
class File extends ObjectBase {

    ;; create the file Object
    __new(a_parms*){
        this._file := fileOpen(a_parms*)
    }

    ;; Seek wrapper
    Seek(a_params*){
        return this._file.Seek(a_params*)
    }

    ;; Tell wrapper
    Tell(){
        return this._file.Tell()
    }

    ;; Close wrapper
    Close(){
        return this._file.Close()
    }

    ;; Position wrapper
    position[] {
        get{
            return this._file.tell()
        }
        set{
            this._file.seek(value)
        }
    }    

    ;; Pos wrapper
    pos[] {
        get{
            return this._file.tell()
        }
        set{
            this._file.seek(value)
        }
    }    

    ; Read wrappers ________________________________
    
        ;; read wrapper
        Read(a_params*){
            return this._file.read(a_params*)
        }
        
        ;; readline wrapper
        Readline(a_params*){
            return this._file.readline(a_params*)
        }

        ;; RawRead wrapper
        RawRead(a_params*){
            return this._file.RawRead(a_params*)
        }
        
        ;; ReadUint wrapper
        ReadUInt(){
            return this._file.ReadUint()
        }

        ;; ReadInt wrapper
        ReadInt(){
            return this._file.ReadInt()
        }

        ;; ReadInt64 wrapper
        ReadInt64(){
            return this._file.ReadInt64()
        }

        ;; ReadShort wrapper
        ReadShort(){
            return this._file.ReadShort()
        }

        ;; ReadChar wrapper
        ReadChar(){
            return this._file.ReadChar()
        }

        ;; ReadUChar wrapper
        ReadUChar(){
            return this._file.ReadUChar()
        }

        ;; ReadDouble wrapper
        ReadDouble(){
            return this._file.ReadDouble()
        }

        ;; ReadFloat wrapper
        ReadFloat(){
            return this._file.ReadFloat()
        }

    ; Write wrappers ________________________________

        ;; write wrapper
        Write(a_params*){
            return this._file.write(a_params*)
        }

        ;; writeline wrapper
        WriteLine(a_params*){
            return this._file.WriteLine(a_params*)
        }

        ;; RawWrite wrapper
        RawWrite(a_params*){
            return this._file.RawWrite(a_params*)
        }

        ;; WriteUint wrapper
        WriteUint(a_num) {
            return this._file.WriteUint(a_num)
        }

        ;; WriteInt wrapper
        WriteInt(a_num) {
            return this._file.WriteInt(a_num)
        }

        ;; WriteInt64 wrapper
        WriteInt64(a_num){
            return this._file.WriteInt64(a_num)
        }

        ;; ReadShort wrapper
        WriteShort(a_num){
            return this._file.WriteShort(a_num)
        }

        ;; WriteChar wrapper
        WriteChar(a_num){
            return this._file.WriteChar(a_num)
        }

        ;; WriteUChar wrapper
        WriteUChar(a_num){
            return this._file.WriteUChar(a_num)
        }

        ;; WriteDouble wrapper
        WriteDouble(a_num){
            return this._file.WriteDouble(a_num)
        }

        ;; WriteFloat wrapper
        WriteFloat(a_num){
            return this._file.WriteFloat(a_num)
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
    getfiles(a_folders=0, a_recurse=0){
        l_obj := []
        loop, % this, % a_folders, % a_recurse
        {
            l_obj.insert(a_loopfilefullpath)
        }
        return l_obj
    }

    ;; returns 1 if the filepattern contains any file
    hasfiles(){
        loop, %this%
        {
            return 1
        }
        return 0
    }

}



