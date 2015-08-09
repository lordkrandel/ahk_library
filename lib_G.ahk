;; Base class for AutoHotkey GUI windows
class g extends Window {

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
    controlSet( a_control, a_subcmd = "", a_param3 = "" ) {
        GuiControl, % this.name ":" a_subcmd, % a_control , % a_param3
    }

    ;; Get default content of a control
    controlGet( a_control, a_subcmd = "", a_param4 = "" ) {
        GuiControlGet, l_ret, % this.name ":" a_subcmd, % a_control, % a_param4
        return l_ret
    }

    ;; Close and unregister all window events
    close() {
        EventDispatcher.unregisterGui(this)
        Gui, % this.name ": Cancel"
        Gui, % this.name ": Destroy"
    }

    ;; Show and register all window events
    show(a_geom="") {
        this.geom := a_geom ? a_geom : {x: "center", y: "center", w: 600, h: 400}
        Gui, % this.name ": +LabelGui +Resize +hwndl_winHwnd"
        Gui, % this.name ": Show", % ""
            . " x" this.geom.x
            . " y" this.geom.y
            . " w" this.geom.w
            . " h" this.geom.h
            , % this.title
            
        this.hwnd := l_winHwnd
        EventDispatcher.registerGui(this)
    }
    
    ;; Hide the gui
    hide() {
        EventDispatcher.unregisterGui(this)
        Gui, % this.name ": Submit"
    }
    
    ;; Hide the GUI in escape
    escape() {
        this.hide()
    }
    
    ;; Stub for the resize event handler
    size() {
    }

}
