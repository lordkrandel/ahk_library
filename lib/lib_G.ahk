#include lib\lib_CORE.ahk
#include lib\lib_WINDOW.ahk
#include lib\lib_EVENTDISPATCHER.ahk

class g extends Window{

    name  := ""
    title := ""

    geom  := { w: 500
             , h: 340
             , x: "center"
             , y: "center" }

    properties := { "geom": "getPos" }

    __Get(aname) {
        n := this.properties[aname]
        if (n){
            return this[n]()
        }
    }

    controlSet( c, subcommand = "", param3 = "" ){
        GuiControl, % this.name ":" subcommand, % c , % param3
    }
    controlGet( c, subcommand = "", param4 = "" ){
        GuiControlGet, s, % this.name ":" subcommand, % c, % param4
        return % s
    }

    close(){
        EventDispatcher.unregisterGui(this)
        Gui, % this.name ": Cancel"
        Gui, % this.name ": Destroy"
    }
    show(){
        g := this.name

        this.geom.x := Core.firstValid( this.geom.x, "center")
        this.geom.y := Core.firstValid( this.geom.y, "center")

        Gui, %g%: +LabelGui +Resize +hwndwinHwnd
        Gui, %g%: Show, % "h" this.geom.h
                       . " w" this.geom.w
                       . " x" this.geom.x
                       . " y" this.geom.y
                       , % this.title

        this.hwnd := winHwnd

        EventDispatcher.registerGui(this)
    }
    hide(){
        EventDispatcher.unregisterGui(this)
        g := this.name
        Gui, %g%: Submit
    }
    escape(){
        this.hide()
    }
    size(){
    }




}
