
class TrayTip {
    show( s, t=1000 ){
        TrayTip, %s%, %A_Space%, 16
        SetTimer, TrayTip_Remove, % t
    }

    clear(){
    TrayTip_Remove:
        SetTimer, TrayTip_Remove, off
        Traytip
        return
    }
}

