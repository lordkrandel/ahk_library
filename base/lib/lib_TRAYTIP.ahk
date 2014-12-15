#include <LIB_CORE>

;; Handles Windows traytips
class TrayTip {
    
    ;; Show a traytip with a timer
    __new( a_s, a_title="", a_timeout=1000, a_options=0){
        TrayTip, % a_title, % a_s, % a_timeout / 1000, 16 + a_options
        SetTimer, TrayTip_Remove, % a_timeout
    }

    ;; Hide and destroy the traytip
    __delete(){
    TrayTip_Remove:
        SetTimer, TrayTip_Remove, off
        Traytip,
        return  ; mandatory
    }

}

;; Traytip test class
class TrayTipTest {

    ;; Run the test
    run(){
        {
            l_tt := new TrayTip("test",, 5000, 1)
            Sleep, 5000
        }
    }
}

;(new TrayTipTest()).run()
;ExitApp
