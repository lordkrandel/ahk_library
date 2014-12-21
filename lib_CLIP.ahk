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

        ; Backup the old value
        l_backup  := ClipBoard

        ; Empty the clipboard
        ClipBoard := ""

        ; Wait for the clipboard to empty
        loop
        {
            if (!clipboard || A_index > 100){
                break
            }
            Sleep, 10
        }

        ; Put the new value
        ClipBoard := a_new_value

        ; Wait for the clipboard to notice the new value
        ClipWait, 2

        ; Paste the clipboard
        SendInput, ^v

        ; Wait some time 
        Sleep, 50

        ; Put the old value in the clipboard
        ClipBoard := l_backup

    }
    
}
