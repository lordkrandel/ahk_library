class GUI {

    getControls(hwnd){
        ctrls := {}
        WinGet, list, ControlList, % "ahk_id " hwnd

        l := list.split("\n")
        for k,v in l {

            ControlGet, id, hwnd,, % v, % "ahk_id " hwnd
            o := Gui.controlGet(id)
            o.insert("classNN", v )

            ctrls.insert(o)
        }
        return ctrls
    }

    controlGet(hwnd){

        static maxSize := 32 * 1024
        t := "ahk_id " hwnd

        VarSetCapacity(txt, maxSize)
        ControlGetText, txt,, %t%
        ControlGetPos, x, y, w, h,,     %t%
        ControlGet, style,   style,,,   %t%
        ControlGet, exstyle, exstyle,,, %t%
        ControlGet, checked, checked,,, %t%
        ControlGet, enabled, enabled,,, %t%
        ControlGet, visible, visible,,, %t%


        o := { "id"        : hwnd
             , "text"      : txt
             , "style"     : style
             , "exstyle"   : exstyle
             , "x"         : x
             , "y"         : y
             , "w"         : w
             , "h"         : h
             , "checked"   : checked
             , "enabled"   : enabled
             , "visible"   : visible }

        return o
    }

}

