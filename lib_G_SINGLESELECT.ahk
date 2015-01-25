#include <LIB_CORE>

;; Single entry selection dialog
class SelectDialog extends g {

    name  := "selectDialog"
    title := "selectDialog"
    win   := { listbox   : 0
             , edit      : 0
             , hotkeys:  { "+Enter"      : "enterSlot"
                         , "Enter"       : "enterSlot" 
                         , "NumPadEnter" : "enterSlot"
                         , "Up"          : "arrowSlot"
                         , "Down"        : "arrowSlot"
                         , "+Up"         : "arrowSlot"
                         , "+Down"       : "arrowSlot" }
             , controls: { "Edit1"       : "filter"    } }
    entries    := ""
    hwnd       := ""

    ;; Constructor
    __new(a_entries="", a_geom="") {
        g := this.name
        Gui, %g%: +Resize 
        Gui, %g%: Font, s10, Verdana
        this.geom := a_geom ? a_geom : {x: "center", y: "center", w: 600, h: 400}

        Gui, %g%: Add, edit, % ""
            . " x" 0 
            . " y" 0  
            . " w" this.geom.w 
            . " h" 20
            . " hwnd" "l_hwndedit"    
            . " g" "EventDispatcher"
        Gui, %g%: Add, listbox, % ""
            . " x" 0 
            . " y" 20 
            . " w" this.geom.w 
            . " h" this.geom.h - 20 
            . " hwnd" "l_hwndlistbox" 
            . " Choose" 0  
            . " 0x100"
            . " +0x1000" ; Multi
        this.listbox  := new Listbox(l_hwndlistbox)
        this.win.edit := l_hwndedit
        this.entries  := a_entries.join("|")
        
    }

    ;; Event that fires when ENTER is pressed on the dialog
    enterSlot() {
        Core.toggleMaxSpeed() 
        
        ; Get all the selected fields
        this.returnValue := this.controlGet(this.listbox.hwnd)
        Core.toggleMaxSpeed()
        this.done()
        this.close()
    }

    ;; Event: selection is done
    done() {
    }

    ;; Event: window is resized
    size() {
        Core.toggleMaxSpeed() 
        this.controlSet( this.listbox.hwnd, "Move", "w" A_GuiWidth " h" A_GuiHeight - 20)
        this.controlSet( this.win.edit,     "Move", "w" A_GuiWidth )
        Core.toggleMaxSpeed() 
    }
    
    ;; Filter entries based on the edit value
    filter() {
        
        ; Maximum speed, no pause
        Core.toggleMaxSpeed() 
        
        ; Filter based on editvalue
        editValue := this.controlGet( this.win.edit )
        if (editValue){
            top := []
            bottom := []
            for k, v in this.entries.split("|") {
                if ( instr(v, editValue) > 0 ){
                    if ( s == 1 ){
                        top.insert(v)
                    } else {
                        bottom.insert(v)
                    }
                }
            }
            entries .= top.join("|") bottom.join("|")
        } else {
            entries .= this.entries
        }
        
        ; Clear old entries        
        entries := "|" entries
        if (entries != "|"){
            ;Preselect the first entry
            entries := regexreplace(entries, "^\|([^\|]*+)\|*", "|$1||")
        }
        
        ; Set the entries on the listbox
        this.listbox.set(entries)
        
        ; Back to normal speed
        Core.toggleMaxSpeed() 
        
   }

    ;; Event: arrow key is pressed
    arrowSlot() {
        l_htk := a_thishotkey
        l_s := "+".in(l_htk)
               ? l_s := l_htk.slice(2).qc().q( "{Shift down}", "{Shift Up}" )
               : l_s := l_htk.qc()
        ControlFocus,, % "ahk_id " this.listbox.hwnd
        Send, % l_s
    }

    ;; Shows the window
    show() {
        base.show()
        this.controlSet(this.win.edit, "", "")
        this.listbox.choose(1)
    }
    
}

