#include lib\\lib_eventdispatcher.ahk

class g {  // ______________________________________________

    win := { name: "",title:"", geom: { w: 500, h: 340 }}
    close(){
        EventDispatcher.unregisterGui(this)
        Gui, % this.win.name ": Cancel"
        Gui, % this.win.name ": Destroy"
    }
    show(){
        v := this.win.name
        EventDispatcher.registerGui(this)
        Gui, %v%: Show, % "h" this.win.geom.h
                       . " w" this.win.geom.w
                       . " x" this.win.geom.x
                       , % this.win.title
    }
    hide(){
        EventDispatcher.unregisterGui(this)
        Gui, %g%: Submit
    }
    escape(){
        this.hide()
    }
    size(){
    }
    controlSet( c, subcommand = "", param3 = "" ){
        GuiControl, % this.win.name ":" subcommand, % c , % param3
    }
    controlGet( c, subcommand = "", param4 = "" ){
        GuiControlGet, s, % this.win.name ":" subcommand, % c, % param4
        return % s
    }

}

