#include <lib_CORE>

;; Clipboard functions
class Clipboard {

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
        Send, ^v

        ; Wait some time 
        Sleep, 50

        ; Put the old value in the clipboard
        ClipBoard := l_backup

    }

}
