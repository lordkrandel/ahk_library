#include <lib_CORE>

test(){
    c := new Doc(A_Scriptname)
    j := new JSONParser("json.js")
    Msgbox, % j.stringify(c.comments)
}
test()
exitApp

;; Base class for documentation objects
class Doc_base {
    __new(m){
        c := m.count()
        Loop, %c%
        {
            v := m.value(A_index)
            if (v){
                k := m.name(A_index)
                this[k] := m.value(A_index)
            }
        }
    }
}

;; Function documentation object
class Doc_function extends Doc_base {
    static regex := "iO)^\s*(?P<name>\w+)\((?P<params>[^)]*?)\)\s*{"
    ;; Constructor
    ;; m: match object
    __new(m){
        base.__new(m)
        this.params := m.params.split(",")
        this.kind := "function"
    }
}

;; Class documentation object
class Doc_class extends Doc_base {
    static regex := "iO)^\s*class\s*(?P<name>\w+)(?:\s*extends\s*(?P<baseclass>\w+))?"
    ;; Constructor
    ;; m: match object
    __new(m){
        base.__new(m)
        this.kind := "class"
    }
}
;; Doc automatically creates markdown from lib sources.
;; The markdown has then to be put into HTML with the proper tool
class Doc {

    ;; Constructor
    ;; f: filename to be parsed
    __new(f){

        this.comments := {}

        Loop, read, %f%
        {

            ;; Look for comments
            if ( RegexMatch(a_loopreadline, "iO)^(?P<indent>\s*;;\s?).*?$", m)){
                c := Core.firstValid(c, {})
                c.insert( a_loopreadline.leftTrim( strlen(m.indent) ) )
                continue
            } else if (!c) {
                ; Not found, keep going
                continue
            }

            ;; The comment refers to the context which follows it
            this.comments.insert({context: a_loopreadline, comments: c})
            c := ""

        }

        ;; Try to build a Doc_class for every comment found
        for k,v in this.comments {
            for k2, class in [ Doc_class, Doc_function] {
                if RegExMatch( v.context, class.regex, m){
                    v.doc := new class(m)
                }
            }
        }

    }

}


