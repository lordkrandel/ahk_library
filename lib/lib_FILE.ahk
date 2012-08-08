#include <lib_CORE>
#include <lib_WIN32>

; File object wrapper
class File {

    ; properties and functions are forwarded
    static properties := Core.swap([ "length", "ateof", "position", "pos", "encoding" ])
    static functions  := Core.swap([ "read", "write", "readline", "writeline", "readnum"
                                   , "writenum", "rawread", "rawwrite", "seek", "tell", "close"])

    ; create the file Object
    __new(file, flags, encoding = ""){
        this.f := fileOpen(file, flags, encoding)
    }

    ; forward the calls
    __call(aname, params*){
        x := ( File.functions[aname.toLower()] ? this.f : base )
        return x[aname](params*)
    }

}

class StdIn extends File {
    __new(){
        this.f := FileOpen( Win32.GetStdHandle(-10), "h `n")
    }
}
class StdOut extends File {
    __new(){
        this.f := FileOpen( Win32.GetStdHandle(-11), "h `n")
    }
}






