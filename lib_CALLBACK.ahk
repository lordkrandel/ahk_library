#include <LIB_CORE>

;; CallbackQueue
class CallbackQueue extends ObjectBase {

    ;; Static; Route the call to the right callback
    route(){
        l_index := a_eventinfo
        l_callback := CallbackQueue[l_index] 
        
        ; non static method
        l_callback.object[l_callback.function].(l_callback.object)
		Win32.SetEvent("Uint", Cron.wake_event)
        
    }

    ;; Destructor
    __delete(){
        this.reset()
    }
    
    reset() {
        for k, v in CallbackQueue {
            CallbackQueue[k] := ""
            CallbackQueue.remove(k)
        }
    }

}

;; An auto_ptr for callbacks
class Callback extends ObjectBase {

    ;; Constructor, registers the callback
    __new(a_object, a_function, a_params="") {
        l_index := CallbackQueue.count() + 1
        this.handle := RegisterCallback("CallbackQueue.route", "F", 3, l_index)
        this.object := a_object
        this.function := a_function
        this.params := a_params.or({})
        this.index := l_index
        CallbackQueue.insert(this)
    }

    ;; Destructor, destroys the callback
    __delete() {
        if (this.handle){
            Win32.GlobalFree("Ptr", this.handle)
        }
    }
}

