#include <lib_g>
#include <lib_CONTROL>
#include %A_ScriptDir%\scripts\ac\optionsDialog.ahk ; Options Dialog
#include %A_ScriptDir%\scripts\ac\acController.ahk  ; Controller

:?*:dba.::
!Space::

    ac.controller.lastHwnd  := WinExist("A")

    if (!ac){
        ac := new Autocomplete()
    }

    ac.controller.setHotkey(A_thishotkey)
    ac.show()

return

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

        g := this.name

        Gui, %g%: +Resize 
        Gui, %g%: Font, s10, Verdana
        Gui, %g%: Add, edit,    x0 y0  w300 h20 hwndhwndedit    gEventDispatcher
        Gui, %g%: Add, listbox, x0 y20          hwndhwndlistbox Choose0 0x100 Multi +0x1000

        this.hwnd     := winhwnd
        this.listbox  := new Listbox(hwndlistbox)
        this.win.edit := hwndedit

    }

    show(){
        base.show()
        this.entries := ( this.controller.firstRun
            ? this.controller.start()
            : this.controller.getEntries( this.controller.currentLevel ) )
        this.populate( this.entries )
    }

    populate(entries) {
        if ( ! entries ) {
            return
        }
        this.entries := entries
        this.controlSet( this.listbox.hwnd, "", Entries )

        val := this.controller.getCurrentLevel().value
        this.controlSet( this.win.edit, "", "" )
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

    tabslot(){
        s := this.controlGet( this.listbox.hwnd )
        if (instr(s,"|")){
            throw "Select only one."
        }
        this.populate( this.controller.changeLevel(1, s) )
    }

    capslockSlot(){
        this.populate( this.controller.changeLevel(-1) )
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
            dsn := this.listbox.get()
            d := new optionsDialog(dsn)
            d.show()
        }
    }

    deselectAll(){
        this.listbox.deselectAll()
    }
    selectAll(){
        this.listbox.selectAll()
    }

    enterSlot(){

        this.hide()

        ; Fastest
        batchlines := A_Batchlines
        setbatchlines, -1

        ; Get all the selected fields
        s := this.controlGet( this.listbox.hwnd )
        s := this.controller.build(s)

        WinActivate, this.controller.lastHwnd

        SendInput, % s

        ; Get back to normal speed
        setbatchlines, % batchlines
    }

    filter() {
        t := this.controlGet( this.win.edit )
        entries := this.Entries
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
        entries := Core.firstValid( entries, "|" )

        this.listbox.set( entries )
        this.listbox.choose(0)
    }

}

return

