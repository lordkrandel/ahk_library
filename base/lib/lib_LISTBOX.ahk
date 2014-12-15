#include <LIB_CORE>

;; Handles ListBox controls
class ListBox {

    ;; Constructor
    __new(a_hwnd){
        this.hwnd := a_hwnd
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
    select( a_entry = 1, a_active = 1 ){
        SendMessage, % Win32.LB_SETSEL, % a_entry, % a_active,,  % "ahk_id " this.hwnd
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
        SendMessage, % Win32.LB_SETTOPINDEX, % l_selected, 0, , % l_id
    }

    ;; Get current value
    getValue() {
        ControlGet, l_ret, Choice,,, % "ahk_id " this.hwnd
        return l_ret
    }    
    
    ;; Get the entries' list
    get(){
        ControlGet, l_list, List,,, % "ahk_id " this.hwnd
        return l_list
    }

    ;; Set the entries' list
    set( a_entries ){
        if (isObject(a_entries)){
            l_entries := "|" a_entries.join("|")
        } else {
            l_entries := a_entries
        }
        this.entries := l_entries
        GuiControl,, % this.hwnd, % l_entries 
    }

}


