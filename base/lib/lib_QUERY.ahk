#include <lib_CORE>

;; Models a DDL command over 
class QueryCommand extends ObjectBase {

    ;; Constructor
    __new(a_params*) {
        l_count := a_params.maxIndex()  
        if (l_count == 0) {
            throw Exception("No constructor accepts 0 parameters ")
            return
        } else if (l_count == 1) {
            this.conn := Odbc.conn
            this.sql  := a_params[1]
        } else if (l_count == 2) {
            this.conn := a_params[1]
            this.sql  := a_params[2]
        } else if (l_count > 2) {
            throw Exception("No constructor accepts more than 2 parameters ")
            return
        }
    }

    ;; Execute
    execute(a_params*) {
        ; try to connect
        try {
            l_command := ComObjCreate("ADODB.Command")
            l_command.ActiveConnection := this.conn
        } catch l_exc {
            l_msg := "Cannot attach the command to the connection`n`nError:`n%s"
            l_msg := l_msg.fmt(l_exc.message) 
            throw Exception(l_msg)
            return
        }
        try {
            l_command.CommandText := this.sql
            l_command.CommandType := 1 ;adCmdText
            l_command.execute(a_params*)
        } catch l_exc {
            l_msg := "Cannot execute command `n`n%s`n`nError:`n%s"
            l_msg := l_msg.fmt(this.sql, l_exc.message) 
            throw Exception(l_msg)
            return
        }
    }

}

;; Models a single  SQL query
class Query extends ObjectBase {
    
    ;; Constructor
    __new(a_params*) {
        l_count := a_params.maxIndex()  
        if (l_count == 0) {
            throw Exception("No constructor accepts 0 parameters ")
        } else if (l_count == 1) {
            this.conn := Odbc.conn
            this.sql  := a_params[1]
        } else if (l_count == 2) {
            this.conn := a_params[1]
            this.sql  := a_params[2]
        } else if (l_count > 2) {
            throw Exception("No constructor accepts more than 2 parameters ")
        }
    }

    ;; Destructor
    __delete() {
        if (this.rs && this.rs.state != 0) {
            this.rs.close()
        }
    }

    sanitize(as){
        as := Regexreplace(as, "i)[^\w\s\\/-_.,]", "")
        return as
    }
    
    ;; Execute the current query
    do() {
        
        ; try to connect
        try {
            this.rs := ComObjCreate("ADODB.Recordset")
            this.rs.ActiveConnection := this.conn
        } catch l_ex {
            l_msg := "Cannot attach the query to the connection`n`nError:`n%s"
            l_msg := l_msg.fmt(l_exc.message) 
            throw Exception(l_msg)
            return
        }

        ; try to retrieve
        try {
            this.rs.Source := this.sql
            this.rs.open()
        } catch l_ex {
            throw Exception("Query failed: " l_ex.message)
            return
        }
        
        ; set first record, if any
        if !(this.rs.EOF){
            this.rs.moveFirst()
        }
         
        return this
    }
    
    ;; execute is an alias to the do() function
    execute() {
        return this.do()
    }
    
    ;; Returns all rows from the query
    fetchAll() {
        l_ret := []
        for k, v in this {
            l_ret.insert(k, v)
        }
        return l_ret
    }
    
    ;; Enumerate rows
    _NewEnum() {
        return new QueryEnum(this.rs)
    }

}


;;  Query recordset enumerator
class QueryEnum extends ObjectBase {
    
    current := 0
    ;; Constructor
    __New(a_recordset) {
        this.recordset := a_recordset
    }
    
    ;; Move to next record
    next(byref a_key, byref a_value){
        
        ; Fetch next record
        this.current ++
        if (this.current == 1) {
            if (this.recordset.EOF) {
                this.recordset.close()
                return false
            }
            this.recordset.moveFirst()
        } else {
            this.recordset.movenext()
        }
        ; Return false if there are no more records
        if (this.recordset.EOF) {
            ; Close cursor
            this.recordset.close()
            return false
        }
        
        ;; Return results as byref parameters
        a_key   := this.current
        a_value := new QueryRecord()
        Loop, % this.recordset.fields.count
        {
            l_field := this.recordset.fields.item(a_index-1)
            a_value.insert( new QueryValue(l_field.name, l_field.value) )
        }
                
        return true
        
    }

}

;; Record class
class QueryRecord extends ObjectBase {

    ;; Get keys array, override
    keys() {
        return this.map("this.__get", "key")
    }
    ;; Get values array, override
    values() {
        return this.map("this.__get", "value")
    }
    toString(a_sep="|") {
        return this.values().join(a_sep)
    }

}

;; Key-pair value 
class QueryValue extends ObjectBase {

    ;; constructor
    __new(a_key, a_value) {
        this.key := a_key
        this.value := a_value
    }
    ;; Convert to string
    toString() {
        l_ret := this.key ": " this.value
        return l_ret
    }

}


