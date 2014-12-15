#include <LIB_CORE>

;; Handles events from a G window. Should be static or singleton.
class EventDispatcher{

    static stack    := {}
    static controls := {}    
 
    ;; Register a GUI to handle its events
    registerGui(a_win){
        EventDispatcher.stack[a_win.hwnd] := a_win
        EventDispatcher.stack[a_win.name] := a_win
        EventDispatcher.toggleHotkeys(a_win, "On")
    }

    ;; Toggle hotkey on a specific window
    toggleHotkeys(a_win, a_state = "Toggle"){
        for k, v in a_win.win.hotkeys {
            Hotkey, IfWinactive, % "ahk_id " a_win.hwnd
            Hotkey, % k, EventDispatcher, % a_state
            Hotkey, IfWinactive,
        }

    }

    ;; Unregister the GUI window's events
    unregisterGui(a_win){
        ; Object.remove() adjusts integer indexes
        ; That's bad because the hwnd is an integer
        EventDispatcher.toggleHotkeys(a_win, "Off")
        EventDispatcher.stack[a_win.hwnd] := ""
        EventDispatcher.stack[a_win.name] := ""
    }

    ;; Event is fired whenever any registered GUI fires an event handling request
    ;; Routes event handling requests to the right G (GUI window class) object
    event(){
    GuiEscape:
    GuiClose:
    GuiSize:
    GuiContextMenu:
    GuiDropFiles:
    EventDispatcher:

        l_name := (A_gui ? A_gui : WinActive())

        eventData := { label : a_thislabel
                     , gui: { name    : l_name
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

            l_eventlabel := a_thislabel
            l_win := EventDispatcher.stack[l_name]

            if (l_eventlabel  == "GuiSize"){
                l_win.size()
            } else if (l_eventlabel == "GuiClose"){
                l_win.close()
            } else if (l_eventlabel == "GuiDestroy"){
                l_win.close()
            } else if (l_eventlabel == "GuiEscape"){
                l_win.escape()
            } else if (a_guievent == "Normal" ){
                controlgetfocus, l_focused_control
                l_callback := l_win.win.controls[l_focused_control]
                l_win[l_callback]()
            } else {
                l_callback := l_win.win.hotkeys[a_thishotkey]
                l_win[l_callback]()
             }

        } catch l_exc {
            throw new Exception("Event handling failed" l_exc.message)
        }
        return
    }

}


