#include <LIB_CORE>

;; Handles any Window
class Window {

    ;; property geometry, get&set
    geom[]{
        get {
            WinGetPos, l_x, l_y, l_w, l_h, % this.hwnd_string
            l_geom := { x: l_x, y: l_y, w: l_w, h: l_h }
            return l_geom
        }
        set {
            l_geom := value
            l_x := l_geom.x
            l_y := l_geom.y
            l_h := l_geom.h
            l_w := l_geom.w
            WinMove, % this.hwnd_string,, % l_x, % l_y, % l_w, % l_h
        }
    }

    ;; property controls, get
    controls[]{
        get {
            if (!this.ctrls){
                l_ret := {}
                WinGet, l_controllist, ControlList, % this.hwnd_string
                for k, v in l_controllist.split("`n"){
                    l_ret.insert( v, new Control(this.hwnd, v) )
                }
                this.ctrls := l_ret
                return l_ret
            }
            return this.ctrls
        }
    }

    ;; Retrieve the geometry as string
    geomToString( a_geom ) {
        l_ret := a_geom.x ? " x" a_geom.x : ""
               . a_geom.y ? " y" a_geom.y : ""
               . a_geom.w ? " w" a_geom.w : ""
               . a_geom.h ? " h" a_geom.h : ""
        l_ret := RegexReplace(l_ret, "^\s*", "")
        return l_ret
    }

    ;; Constructor
    __New(a_hwnd){

        if a_hwnd is not number 
        {
            l_hwnd := WinExist(a_hwnd)
        } else {
            l_hwnd := a_hwnd
        }

        l_hwnd_string := "ahk_id " l_hwnd
        this.hwnd := l_hwnd
        this.hwnd_string := l_hwnd_string

        WinGetTitle, l_title, % this.hwnd_string
        this.title := l_title

    }

}

