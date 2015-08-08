;; Autocomplete dialog class
class autoComplete extends g {  ; ________________________

    name  := "acWin"
    title := "autoComplete"
    win   := { listbox   : 0
             , edit      : 0
             , hotkeys:  { "Tab"      : "tabslot"
                         , "vkBE"     : "tabslot"
                         , "Capslock" : "capslockSlot"
                         , "+Enter"   : "enterSlot"
                         , "Enter"    : "enterSlot"
                         , "NumPadEnter" : "enterSlot"
                         , ","        : "enterSlot"
                         , "+,"       : "enterSlot"
                         , "Up"       : "arrowSlot"
                         , "Down"     : "arrowSlot"
                         , "+Up"      : "arrowSlot"
                         , "+Down"    : "arrowSlot"
                         , "^a"       : "selectAll"
                         , "^d"       : "deselectAll"
                         , "^o"       : "odbcConfig"   }
             , controls: { "Edit1"    : "filter"     } }
    geom       := { w: 380, h: 537 }
    Entries    := ""
    hwnd       := ""
    controller := new acController(this)

    __new(){
        l_name := this.name
        Gui, %l_name%: +Resize 
        Gui, %l_name%: Font, s10, Verdana
        Gui, %l_name%: Add, edit,    x0 y0  w300 h20 hwndhwndedit    gEventDispatcher
        Gui, %l_name%: Add, listbox, x0 y20          hwndhwndlistbox Choose0 0x100 Multi +0x1000
        this.hwnd     := winhwnd
        this.listbox  := new Listbox(hwndlistbox, this.name)
        this.win.edit := hwndedit
    }

    show(){
        base.show()
        this.entries := (this.controller.firstRun
            ? this.controller.start()
            : this.controller.getEntries(this.controller.currentLevel))
        this.populate(this.entries)
    }

    close(){
        this.hide()
    }
    
    populate(entries) {
        if !(entries) {
            return
        }
        this.entries := entries
        this.controlSet(this.listbox.hwnd, "", entries)

        val := this.controller.getCurrentLevel().value

        this.controlSet(this.win.edit, "", "")
        Gui, % this.name ": Show",, % this.controller.getTitle()
        this.listbox.deselectAll()

        if (val){
            controlfocus,, % "ahk_id " this.listbox.hwnd
            if (instr(entries, val)){
                this.listbox.choose(val)
            }
        } else {
            this.listbox.choose(0)
        }
        controlfocus,, % "ahk_id " this.win.edit
    }

    size(){
        bl := A_BatchLines
        SetBatchLines, 1000
        this.controlSet( this.listbox.hwnd, "Move", "w" A_GuiWidth " h" A_GuiHeight - 20)
        this.controlSet( this.win.edit,     "Move", "w" A_GuiWidth )
        SetBatchLines, %bl%
    }

    tabSlot(){
        s := this.controlGet( this.listbox.hwnd )
        if (instr(s,"|")){
            throw "Select only one."
        }
        this.populate( this.controller.nextLevel(s) )
    }

    capslockSlot(){
        this.populate( this.controller.prevLevel() )
    }

    arrowSlot(){
        htk := a_thishotkey

        s := "+".in(htk)
            ? s := htk.slice(2).qc().q( "{Shift down}", "{Shift Up}" )
            : s := htk.qc()
        ControlFocus,, % "ahk_id " this.listbox.hwnd
        Send, % s
    }

    odbcConfig(){
        if (this.controller.currentLevel == 0){
            dsn := this.listbox.getValue()
            d := new optionsDialog(dsn)
            d.show()
        }
    }

    enterSlot(){
        global ac 

        ; Fastest
        batchlines := A_Batchlines
        setbatchlines, -1

        ; Get all the selected fields
        s := this.controlGet( this.listbox.hwnd )
        s := this.controller.build(s)
        
        this.hide()

        ; Paste text to the control
        Clip.ensurePaste(s)

        ; Get back to normal speed
        setbatchlines, % batchlines
    }

    deselectAll(){
        this.listbox.deselectAll()
    }
    selectAll(){
        this.listbox.selectAll()
    }

    filter() {
        t := this.controlGet( this.win.edit )
        entries := this.entries
        if (t != ""){
            arr     := entries.split("|", "")
            entries := ""
            top     := ""
            for k, v in arr {
                s := instr(v,t)
                if ( s > 0 ){
                    if ( s == 1 ){
                        top     .= "|" v
                    } else {
                        entries .= "|" v
                    }
                }
            }
        }

        entries := top entries
        entries := entries.or("|")

        this.listbox.set(entries)
        this.listbox.choose(0)
    }
}
