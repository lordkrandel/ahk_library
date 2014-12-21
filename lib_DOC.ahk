#include <lib_CORE>

;; Base class for documentation objects
class Doc_base extends ObjectBase {

    ;; constructor
    ;; a_match: match object
    __new(a_match){
        l_count := a_match.count()
        Loop, % l_count
        {
            v := a_match.value(A_index)
            if (v){
                k := a_match.name(A_index)
                this[k] := a_match.value(A_index)
            }
        }
    }
}

;; Function documentation object
class Doc_function extends Doc_base {

    ;; regex string corresponding to a function
    static regex := "iO)^\s*(?P<name>\w+)\((?P<params>[^)]*?)\)\s*{"

    ;; constructor
    ;; a_match: match object
    __new(a_match){
        base.__new(a_match)
        this.params := a_match.params.split(",")
        this.kind := "function"
    }
}

;; Class documentation object
class Doc_class extends Doc_base {

    ;; regex string corresponding to a class
    static regex := "iO)^\s*class\s*(?P<name>\w+)(?:\s*extends\s*(?P<baseclass>\w+))?"

    ;; constructor
    ;; m: match object
    __new(a_match){
        base.__new(a_match)
        this.kind := "class"
    }
}
;; Doc automatically creates markdown from lib sources.
;; The markdown has then to be put into HTML with the proper tool
class Doc extends ObjectBase {

    ;; constructor
    ;; a_filename: name of the file to be parsed
    __new(a_filename){

        this.comments := {}

        Loop, read, % a_filename
        {

            ;; Look for comments
            if ( RegexMatch(a_loopreadline, "iO)^(?P<indent>\s*;;\s?).*?$", l_match)){
                l_comment := l_comment.or({})
                l_comment.insert( a_loopreadline.leftTrim( strlen(l_match.indent) ) )
                continue
            } else if !(l_comment) {
                ; Not found, keep going
                continue
            }

            ;; The comment refers to the context which follows it
            this.comments.insert({context: a_loopreadline, comments: l_comment})
            l_comment := ""

        }

        ;; For each comment try to build a Doc_class
        this.doc_objects := {}
        for k, v in this.comments {
            for k2, l_class in [ Doc_class, Doc_function] {
                if RegExMatch( v.context, l_class.regex, l_match){
                    this.doc_objects.insert( new Doc_class(l_match) )
                }
            }
        }
    }

}


