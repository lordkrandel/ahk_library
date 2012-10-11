class Control {

    properties := { geom        : "getPos"
                  , text        : "getText"
                  , description : "getDescription"
                  , style       : "getOtherProperty"
                  , exStyle     : "getOtherProperty"
                  , checked     : "getOtherProperty"
                  , visible     : "getOtherProperty" }

    __Get(aname) {
        n := this.properties[aname]
        if (n){
            return this[n]( aname )
        }
    }

    __New(hwnd, ClassNN = ""){
        if (!ClassNN){
            this.hwnd := hwnd
        } else {
            ControlGet, h, hwnd,, % classNN, % "ahk_id " hwnd
            this.hwnd := h
        }
    }

    getDescription( aname = ""){
        return { geom    : this.geom
               , text    : this.text
               , style   : this.style
               , exStyle : this.exStyle
               , checked : this.checked
               , visible : this.visible }
    }
    getPos(){
        ControlGetPos, x, y, w, h,, % "ahk_id " this.hwnd
        return { x: x, y: y, w: w, h: h }
    }
    getText(){
        ControlGetText, txt,, % "ahk_id " this.hwnd
        return txt
    }
    getOtherProperty(aname){
        ControlGet, result, %aname%,,, % "ahk_id " this.hwnd
        return result
    }
}

