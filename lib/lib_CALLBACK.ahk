class Callback {

    ; A sort of auto_ptr for callbacks

    event(){
        Msgbox, % this.__class " callback triggered"
    }

    __new(options = "", paramCount = "", id = ""){
        this.addr := RegisterCallback( this.__class ".event" , options, paramCount, id )
    }

    __delete(){
        if (this.addr){
            DllCall("GlobalFree", "Ptr", this.addr)
        }
    }
}

