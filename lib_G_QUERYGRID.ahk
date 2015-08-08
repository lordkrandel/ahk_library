;; Visualization grid for query
class QueryGrid extends g {

    name  := "QueryGrid"
    title := "QueryGrid"
    hwnd  := ""
    win   := { listview  : 0 
               , font : "Lucida Console"}

    ;; Constructor
    __new(a_db, a_sql, a_params*) {

        g := this.name
        
        l_keys := []
        l_values := []

        l_q := new Query(a_db.conn, a_sql).do()
        for i, l_row in l_q {
            l_values[i] := []
            for j, l_field in l_row {
                if (i == 1){
                    l_keys.insert(l_field.key)
                }
                l_values[i,j] := l_field.value
            }
        }
        if (!l_values.maxindex() ){
            throw Exception("Nessun documento trovato fra quelli specificati")
        }
        
        Gui, %g%: Default
        Gui, %g%: Margin, 0, 0
        Gui, %g%: +Resize

        Gui, %g%: Add, ListView, % ""
            . "hwnd" "l_hwndlistview" 
            . " x" 0
            . " y" 0
            , % l_keys.join("|")

        this.win.listview := l_hwndlistview

        for i, l_row in l_values {
            LV_Add()
            for j, l_value in l_row {
                LV_Modify(i, "Col" j, l_value)
                LV_ModifyCol(j, 100)
            }
        }

        this.show()
        this.controlSet( this.win.listview, "Move", "w" this.geom.w " h" this.geom.h )
        
    }

    ;; Event: window is resized
    size() {
        this.controlSet( this.win.listview, "Move", "w" A_Guiwidth " h" A_guiheight )
    }

    close(){
        ExitApp
    }
    escape(){
        this.close()
    }
}

