#include <LIB_CORE>

;; Single entry selection dialog
class selectDialog extends g {

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
    geom       := ""
    entries    := ""
    hwnd       := ""

    ;; Constructor
    __new( a_entries="", a_geom=""){

        g := this.name

        Gui, %g%: +Resize 
        Gui, %g%: Font, s10, Verdana
        Gui, %g%: Add, edit,    x0 y0  h20 hwndhwndedit    gEventDispatcher
        Gui, %g%: Add, listbox, x0 y20     hwndhwndlistbox Choose0  0x100 +0x1000 ; Multi

        this.listbox  := new Listbox(hwndlistbox)
        this.win.edit := hwndedit
        this.entries  := "|".join(a_entries)
        this.geom     := Core.firstvalid(a_geom, { w: 400, h: 300 })
    }

    ;; Event that fires when ENTER is pressed on the dialog
    enterSlot(){
        Core.toggleMaxSpeed() 
        this.hide()

        ; Get all the selected fields
        this.returnValue := this.controlGet( this.listbox.hwnd )
        
        this.close()
        Core.toggleMaxSpeed()

        this.done()        
    }

    ;; Event: selection is done
    done(){
    }

    ;; Event: window is resized
    size(){
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
            entries .= "|".join(top) "|".join(bottom)
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
    arrowSlot(){
        htk := a_thishotkey

        s := "+".in(htk)
            ? s := htk.slice(2).qc().q( "{Shift down}", "{Shift Up}" )
            : s := htk.qc()
        ControlFocus,, % "ahk_id " this.listbox.hwnd
        Send, % s
    }

    ;; Shows the window
    show(){
        base.show()
        this.listbox.set(this.entries)
        this.controlSet( this.win.edit, "", "" )
        this.listbox.choose(0)
    }
    
}

