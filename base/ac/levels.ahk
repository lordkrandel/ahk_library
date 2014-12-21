;; GUI Iteration base class
class Level extends ObjectBase {
    
    ;; constructor over existing ODBC class
    __new(a_odbc){
        this.odbc := a_odbc
    }

    ;; virtual method
    getDefault(){
    }

    ;; virtual method
    getEntries(a_value=""){
    }

}

;; DSN SELECTion GUI Iteration
class DsnLevel extends Level{
    name := "DSN"

    ;; Get DSN entries FROM the registry
    getEntries( a_value="" ) {
        l_ret := "|" OdbcReg.dsnList.join("|")
        return l_ret
    }

    ;; Read the default FROM the registry
    getDefault(){
        return OdbcReg.default.dsn
    }

}

;; Table owner SELECTion GUI Iteration
class OwnerLevel extends Level{
    name := "Owner"

    ;; Return the default owner FROM the registry
    getDefault(){
        return OdbcReg.default.owner
    }

    ;; Return the table owners' list
    getEntries(a_value=""){

        ; Read the settings FROM the registry
        this.odbc.settings := OdbcReg.loadDsn(a_value)

        ; Connect or fail
        this.odbc.connect()

        ; Retrieve table owners
        ls_query =
        (
            SELECT distinct
               creator
            FROM
               SYS.SYScatalog
            ORDER BY
               creator
            ;
        )
        l_query := new Query( this.odbc.conn, ls_query ).do()

        ; Loop over results and compose the string
        loop {
            l_ret := l_ret "|" l_query.rs.fields.item("creator").value
            l_query.rs.movenext()
        } until (l_query.rs.EOF)

        return l_ret

    }
}

;; Table level GUI Iteration
class TableLevel extends Level { 
    name := "Tables"

    ;; Retrieve all the tables of the owner
    getEntries(a_value=""){
    
        ; Transform to uppercase
        l_value := a_value.toUpper()

        ; Connect to the source
        this.odbc.connect()

        ; Retrieve all the tables
        ls_query =
        (
            SELECT
               creator,
               tname
            FROM
               SYS.SYScatalog
            WHERE
               upper(creator) = '%l_value%'
            ORDER BY
               creator,
               tname
            ;
        )
        l_query := new Query(this.odbc.conn, ls_query ).do()

        ; Loop over results and compose the string
        loop {
            l_ret := l_ret "|" l_query.rs.fields.item("tname").value
            l_query.rs.movenext()
        } until (l_query.rs.EOF)

        return l_ret

    }
}

;; Table Columns level GUI Iteration
class ColumnLevel extends Level {
    name := "Columns"

    ;; Retrieve all columns FROM a given table
    getEntries(a_value=""){

        ; Try to connect
        this.odbc.connect()

        ; Compose the query string
        ls_query =
        (
            SELECT
                column_name
            FROM
                 SYS.SYScolumn
                    join SYS.SYStable
            WHERE
                table_name = '%a_value%'
            ORDER BY 
                column_id
            ;
        )

        ; Retrieve all columns
        l_query := new Query(this.odbc.conn, ls_query ).do()
        
        ; Compose the result string
        loop {
            l_ret := l_ret "|" l_query.rs.fields.item("column_name").value
            l_query.rs.movenext()
        } until (l_query.rs.EOF)

        return l_ret
    }
}
