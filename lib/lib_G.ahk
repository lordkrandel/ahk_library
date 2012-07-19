#include lib\lib_CORE.ahk
#include lib\\lib_WINDOW.ahk
#include lib\\lib_CONTROL.ahk
#include lib\\lib_EVENTDISPATCHER.ahk

class g {

    win := { name  : ""
           , title : ""
           , geom: { w: 500, h: 340, x: "center", y: "center"} }

    properties := { "geom" : "getPos" }

    __Get(aname) {
        n := this.properties[aname]
        if (n){
            return this[n]()
        }
    }

    controlSet( c, subcommand = "", param3 = "" ){
        GuiControl, % this.win.name ":" subcommand, % c , % param3
    }
    controlGet( c, subcommand = "", param4 = "" ){
        GuiControlGet, s, % this.win.name ":" subcommand, % c, % param4
        return % s
    }

    close(){
        EventDispatcher.unregisterGui(this)
        Gui, % this.win.name ": Cancel"
        Gui, % this.win.name ": Destroy"
    }
    show(){
        g := this.win.name

        this.win.geom.x := Core.firstValid( this.win.geom.x, "center")
        this.win.geom.y := Core.firstValid( this.win.geom.y, "center")

        Gui, %g%: +LabelGui +Resize +hwndwinHwnd
        Gui, %g%: Show, % "h" this.win.geom.h
                       . " w" this.win.geom.w
                       . " x" this.win.geom.x
                       . " y" this.win.geom.y
                       , % this.win.title

        this.win.hwnd := winHwnd

        EventDispatcher.registerGui(this)
    }
    hide(){
        EventDispatcher.unregisterGui(this)
        g := this.win.name
        Gui, %g%: Submit
    }
    escape(){
        this.close()
    }
    size(){
    }
    getPos(){
        WinGetPos, x, y, w, h, % "ahk_id " this.win.hwnd
        return { x: x, y: y, w: w, h: h}
    }

}
