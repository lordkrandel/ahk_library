class Window {

    properties := { geom     : "getPos"
                  , controls : "getControls" }

    geomToString( o ) {
        s := o.x ? " x" o.x : ""
           . o.y ? " y" o.y : ""
           . o.w ? " w" o.w : ""
           . o.h ? " h" o.h : ""
        return RegexReplace(s, "^\s*", "")
    }

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

    getControls() {
        if (!this.ctrls){
            o := {}
            WinGet, list, ControlList, % "ahk_id " this.hwnd
            for k, v in list.split("`n"){
                o.insert( v, new Control(this.hwnd, v) )
            }
            this.ctrls := o
            return o
        }
        return this.ctrls
    }
    getPos(){
        WinGetPos, x, y, w, h, % "ahk_id " this.hwnd
        return { x: x, y: y, w: w, h: h }
    }
    setPos( x = "", y = "", w = "", h = "" ){
        if (isobject(x)){
            o := x
            x := o.x
            y := o.y
            h := o.h
            w := o.w
        }
        WinMove, % "ahk_id " this.hwnd,, % x, % y, % w, % h
    }


}

