class ListBox {

    __new(hwnd){
        this.hwnd := hwnd
    }
    selectAll(){
        this.select( 1, -1 )
    }
    deselectAll(){
        this.select( 0, -1 )
    }
    select( a = 1, i = 1 ){
        LB_SETSEL := 0x185
        SendMessage, % LB_SETSEL, % a, % i,,  % "ahk_id " this.hwnd
    }
    choose( c ) {
        LB_SETTOPINDEX := 0x197
        LB_GETCURSEL   := 0x188
        this.deselectAll()
        if (c.is("number")){
            this.select(1, c)
            sel := c
        } else {
            Control, ChooseString, %c%, , % "ahk_id " this.hwnd
            SendMessage, % LB_GETCURSEL, 0, 0, , % "ahk_id" this.hwnd
            sel := ErrorLevel
        }
        SendMessage, % LB_SETTOPINDEX, % sel,0,, % "ahk_id " this.hwnd
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


