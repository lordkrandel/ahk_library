#include <LIB_CORE>

;; Handles Windows traytips
class TrayTip extends ObjectBase {
    
    ;; Show a traytip with a timer
    show( a_s, a_title="", a_timeout=1000, a_options=0){
        TrayTip, % a_title, % a_s, % a_timeout/1000 , 16 + a_options
        SetTimer, TrayTip_Remove, % a_timeout
        return
    TrayTip_Remove:
        SetTimer, TrayTip_Remove, off
        Traytip,
        return  ; mandatory
    }

}
