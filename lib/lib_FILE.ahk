#include <lib_CORE>

class File {

    static properties := Core.swap([ "length", "ateof", "position", "pos", "encoding" ])
    static functions  := Core.swap([ "read", "write", "readline", "writeline", "readnum"
                                   , "writenum", "rawread", "rawwrite", "seek", "tell", "close"])

    __new(file, flags, encoding = ""){
        this.f := fileOpen(file, flags, encoding)
    }

    __call(aname, params*){
        x := ( File.functions[aname.toLower()] ? this.f : base )
        return x[aname](params*)
    }

}

class StdIn extends File {
    __new(){
        this.f := FileOpen(DllCall("GetStdHandle", "int", -10, "ptr"), "h `n")
    }
}
class StdOut extends File {
    __new(){
        this.f := FileOpen(DllCall("GetStdHandle", "int", -11, "ptr"), "h `n")
    }
}






