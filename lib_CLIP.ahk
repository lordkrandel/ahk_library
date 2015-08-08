#include <lib_CORE>

;; Clipboard functions
class Clip extends ObjectBase {

    ;; Copy to clipboard and wait
    copy(){
        Send, ^c
        Sleep, 50
        ClipWait,
        return % ClipBoard
    }

    ;; Paste from clipboard and wait
    paste(a_text){
        Clipboard := a_text
        ClipWait,
        Send, ^v
    }

    ;; Paste from clipboard and ver
    ensurePaste(a_new_value){

        ; Send as text
        Clipboard := a_new_value
        ClipWait, 2
        Send, ^v

    }

}





