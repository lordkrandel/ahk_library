
class GUI {

    getControls(hwnd){
        windows := {}
        WinGet, controls, list, % "ahk_id " hwnd
        loop, %controls%
        {
            ctrl := controls%a_index%
            WinGet, str, ControlList, % "ahk_id " ctrl
            Loop, parse, str, \n
            {
                if ( instr(a_loopfield, "button") == 1) {
                    ControlGet, tmp, checked,, %A_loopfield%, % "ahk_id " ctrl
                    windows[ ctrl ].checked := tmp
                }
                ControlGetText, temp, %A_loopfield%, % "ahk_id " ctrl
                windows[ ctrl ].text := tmp
            }
        }
        return windows
    }

}

