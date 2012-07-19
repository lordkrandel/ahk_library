#include lib\lib_CORE.ahk
#include lib\lib_CONTROL.ahk

class Window {

    properties := { geom     : "getPos"
                  , controls : "getControls" }

    __New(hwnd){

        if hwnd is not number
        {
            hwnd := WinExist(hwnd)
        }

        t := "ahk_id " hwnd
        this.hwnd := hwnd

        WinGetTitle, title, %t%
        this.title := title

    }

    __Get(aname) {
        n := this.properties[aname]
        if (n){
            return this[n]()
        }
    }

    getPos(){
        WinGetPos, x, y, w, h, % "ahk_id " this.hwnd
        return { x: x, y: y, w: w, h: h }
    }

    getControls() {
        if (!this.ctrls){
            o := {}
            WinGet, list, ControlList, % "ahk_id " this.hwnd
            for k, v in list.split("\n"){
                o.insert( v, new Control(this.hwnd, v) )
            }
            this.ctrls := o
            return o
        }
        return this.ctrls
    }

}

