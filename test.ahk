#include <lib_CORE>
#include <lib_JSON>
#include <lib_FILE>

test(){
    c := new ClassDoc("test.ahk")
    j := new JSONParser("json.js")
    Msgbox, % j.stringify(c.comments)
}
test()
exitApp

;; ClassDoc automatically creates markdown from lib sources.
;; The markdown has then to be put into HTML with the proper tool
class ClassDoc {

    ;; **f**: name of the file to be parsed
    __new(f){

        this.comments := {}

        Loop, read, %f%
        {

            ;; Look for comments
            if ( RegexMatch(a_loopreadline, "iOS)^(?P<indent>\s*;;\s?).*?$", m)){
                c := Core.firstValid(c, {})
                c.insert( a_loopreadline.leftTrim( strlen(m.indent) ) )
                continue
            } else if (!c) {
                ; Not found, keep going
                continue
            }

            ;; The comment refers to the line which follows it
            this.comments.insert({line: a_loopreadline, comments: c})
            c := ""

        }

    }

}


