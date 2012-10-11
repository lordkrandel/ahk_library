class EventDispatcher{

    static stack    := {}
    static controls := {}
    registerGui(w){
        EventDispatcher.stack[w.hwnd] := w
        EventDispatcher.stack[w.name] := w
        EventDispatcher.toggleHotkeys(w, "On")
    }

    toggleHotkeys(w, to = "Toggle"){

        for k,v in w.win.hotkeys {
            Hotkey, IfWinactive, % "ahk_id " w.hwnd
            Hotkey, % k, EventDispatcher, %to%
            Hotkey, IfWinactive,
        }

    }

    unregisterGui(w){
        ; Object.remove() adjusts integer indexes
        ; That's bad because the hwnd is an integer
        EventDispatcher.toggleHotkeys(w, "Off")
        EventDispatcher.stack[w.hwnd] := ""
        EventDispatcher.stack[w.name] := ""
    }

    event(){
    GuiEscape:
    GuiClose:
    GuiSize:
    GuiContextMenu:
    GuiDropFiles:
    EventDispatcher:

        name := (A_gui ? A_gui : WinActive())

        eventData := { label : a_thislabel
                     , gui: { name    : name
                            , control : a_guicontrol
                            , event   : a_guievent
                            , info    : a_eventinfo
                            , geom    : { x : a_guix
                                        , y : a_guiy
                                        , w : a_guiwidth
                                        , h : a_guiheight }
                            , hotkey  : a_thishotkey
                            , menu    : { name : a_thismenu
                                        , item : a_thismenuitem
                                        , pos  : a_thismenuitempos } } }

        try {

            label := a_thislabel
            w := EventDispatcher.stack[name]

            if (label  == "GuiSize"){
                w.size()
            } else if (label == "GuiClose"){
                w.close()
            } else if (label == "GuiDestroy"){
                w.close()
            } else if (label == "GuiEscape"){
                w.escape()
            } else if (a_guievent == "Normal" ){
                controlgetfocus, cont
                slot := w.win.controls[cont]
                w[slot]()
            } else {
                slot := w.win.hotkeys[a_thishotkey]
                w[slot]()
             }

        } catch e {
            throw e
        }

        return

    }
}


