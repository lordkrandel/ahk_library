#include <lib_CORE>

;; Base class for AutoHotkey GUI windows
class g extends Window{

    name  := ""
    title := ""
    
    ;; Geometry property is overridden
    geom[]
    {
        get {
            return this._geom
        }
        set {
            this._geom := value
        }
    }

    ;; Set default content of a control
    controlSet( a_control, a_subcmd = "", a_param3 = "" ){
        GuiControl, % this.name ":" a_subcmd, % a_control , % a_param3
    }

    ;; Get default content of a control
    controlGet( a_control, a_subcmd = "", a_param4 = "" ){
        GuiControlGet, l_ret, % this.name ":" a_subcmd, % a_control, % a_param4
        return % l_ret
    }

    ;; Close and unregister all window events
    close(){
        EventDispatcher.unregisterGui(this)
        Gui, % this.name ": Cancel"
        Gui, % this.name ": Destroy"
    }

    ;; Show and register all window events
    show(){
        this.geom.x := this.geom.x.or("center")
        this.geom.y := this.geom.y.or("center")
        Gui, % this.name ": +LabelGui +Resize +hwndwinHwnd"
        Gui, % this.name ": Show", % "h" this.geom.h
                         . " w" this.geom.w
                         . " x" this.geom.x
                         . " y" this.geom.y
                         , % this.title

        this.hwnd := winHwnd
        EventDispatcher.registerGui(this)
    }
    
    ;; Hide the gui
    hide(){
        EventDispatcher.unregisterGui(this)
        Gui, % this.name ": Submit"
    }
    
    ;; Hide the GUI in escape
    escape(){
        this.hide()
    }
    
    ;; Stub for the resize event handler
    size(){
    }

}
