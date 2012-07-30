class ListBox {

    __new(hwnd){
        this.hwnd := hwnd
    }
    selectAll(){
        this.select( -1 )
    }
    deselectAll(){
        this.select( 0 )
    }
    select( i = 1){
        LB_SETSEL := 0x185
        PostMessage, % LB_SETSEL, 0, % i,,  % "ahk_id " this.hwnd
    }
    choose( c ) {
        s := c.is("number") ? "Choose" : "ChooseString"
        Control, %s%, %c%, , % "ahk_id " this.hwnd
    }
    set( e ){
        if (isObject(e)){
            e := "|" "|".join(e)
        }
        this.entries := e
        GuiControl,, % this.hwnd, % e 
    }
    get(){
        ControlGet, list, List,,, % "ahk_id " this.hwnd
    }
}


