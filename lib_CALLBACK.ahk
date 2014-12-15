#include <LIB_CORE>

;; An auto_ptr for callbacks
class Callback {

    ;; The actual registered callback
    event(){
        Msgbox, % this.__class " callback triggered"
    }

    ;; Constructor, registers the callback
    __new(a_options = "", a_paramCount = "", a_id = ""){
        this.addr := RegisterCallback( this.__class ".event" , a_options, a_paramCount, a_id )
    }

    ;; Destructor, destroys the callback
    __delete(){
        if (this.addr){
            DllCall("GlobalFree", "Ptr", this.addr)
        }
    }

}

