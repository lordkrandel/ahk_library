#include <lib_CORE>

;; Window Control class
class Control {

    properties := { geom        : "getPos"
                  , text        : "getText"
                  , description : "getDescription"
                  , style       : "getOtherProperty"
                  , exStyle     : "getOtherProperty"
                  , checked     : "getOtherProperty"
                  , visible     : "getOtherProperty" }


    ;; Constructor
    __New(a_hwnd, a_ClassNN = ""){
        if (!ClassNN){
            this.hwnd := a_hwnd
        } else {
            ControlGet, l_ret, hwnd,, % a_classNN, % "ahk_id " a_hwnd
            this.hwnd := l_ret
            this.hwnd_string := "ahk_id " this.hwnd
        }
    }

    ;; Setup Getters 
    __Get(a_name) {
        l_property := this.properties[a_name]
        if (l_property){
            return this[l_property]( a_name )
        }
    }

    ;; Return an object description 
    getDescription( aname = ""){
        return { geom    : this.geom
               , text    : this.text
               , style   : this.style
               , exStyle : this.exStyle
               , checked : this.checked
               , visible : this.visible }
    }

    ;; Geometry getter
    getPos(){
        ControlGetPos, a_x, a_y, a_w, a_h,, % this.hwnd_string
        return { x: a_x, y: a_y, w: a_w, h: a_h }
    }

    ;; Text getter
    getText(){
        ControlGetText, l_text,, % this.hwnd_string
        return l_text
    }

    ;; Getter for other properties
    getOtherProperty(a_name){
        ControlGet, l_ret, % a_name,,, % this.hwnd_string
        return l_ret
    }

}

