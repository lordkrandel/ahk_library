#include <LIB_CORE>

;; Handles ListBox controls
class ListBox extends ObjectBase {

    ;; Constructor
    __new(a_hwnd, a_parentwindow = ""){
        this.hwnd := a_hwnd
        this.parentwindow := a_parentwindow
    }

    ;; Select all entries
    selectAll(){
        this.select( 1, -1 )
    }

    ;; Deselect all entries
    deselectAll(){
        this.select( 0, -1 )
    }

    ;; Select/deselect specified entries
    select( a_active = 1, a_entry = 1 ){
        l_id := "ahk_id " this.hwnd
        if (a_active = 1 && a_entry > 0) {
            Control, Choose, % a_entry,, % l_id
        } else {
            SendMessage, % Win32.LB_SETSEL, % a_active, % a_entry,, % l_id
        }
    }

    ;; Choose an entry from the listbox
    choose( a_entry ) {
        l_id := % "ahk_id " this.hwnd
        this.deselectAll()
        if (a_entry.is("number")){
            this.select(1, a_entry)
            l_selected := a_entry
        } else {
            Control, ChooseString, % a_entry, , % l_id
            SendMessage, % Win32.LB_GETCURSEL, 0, 0, , % l_id
            l_selected := ErrorLevel
        }
        SendMessage, % Win32.LB_SETTOPINDEX, % l_selected - 1, 0, , % l_id
    }

    ;; Get current value
    getValue() {
        GuiControlGet, l_ret, % this.parentwindow ":", % "ahk_id " this.hwnd
        return l_ret
    }    
    
    ;; Get the entries' list
    get() {
        ControlGet, l_ret, List,,, % "ahk_id " this.hwnd
        return l_ret.split("`n")
    }

    ;; Set the entries' list
    set(a_entries) {
        if (isObject(a_entries)) {
            l_entries := "|" a_entries.join("|")
        } else {
            l_entries := a_entries
        }
        this.entries := l_entries
        l_parentwindow := this.parentwindow
        guicontrol, % l_parentwindow ":", % this.hwnd, % l_entries
    }

}


