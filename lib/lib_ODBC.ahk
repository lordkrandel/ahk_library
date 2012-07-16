#include lib\\lib_CORE.ahk

class Query {
    query := ""
    conn  := ""
    rs    := ""

    __new(conn, text){
        this.conn := conn
        try {
            this.do(text)
        } catch e {
            return ""
        }
    }
    __delete(){
        if (this.rs && this.rs.state != 0){
            this.rs.close()
        }
    }

    do(q){
        this.query := q

        this.rs := ComObjCreate("ADODB.Recordset")
        this.rs.ActiveConnection := this.conn
        this.rs.Source := q
        this.rs.open()
        this.rs.moveFirst()
        return this.rs
    }

}

class ODBC {

    settings  := ""
    conn      := ""
    connected := 0

    __new( settings = "" ){
        if (settings){
            this.settings := settings 
        } else {
            this.loadFromRegistry()
        }
    }

    __delete(){
        this.conn.close()
        this.conn := ""
        this.connected := 0
    }


    connect(){

        try {
            if (this.connected){
                this.conn.close()
                this.conn := ""
                this.connected := 0
            }

            this.conn := ComObjCreate("ADODB.Connection")

            s := this.settings
            this.conn.ConnectionString := "dsn=" s.dsn ";uid=" s.uid ";pwd=" s.pwd ";"

            this.conn.Open()

            this.connected := 1
        } catch e {
            throw e
        }
    }

    loadFromRegistry(){
        this.settings := Core.firstValid( OdbcReg.load() )
        return this.settings
    }

}


class OdbcReg {

    static baseKey := "HKEY_LOCAL_MACHINE"
    static subKey  := "SOFTWARE\\ODBC\\ODBC.INI\\"
    static default := { dsn: "", owner: "" }
    static dsnList := ""

    loadDsn(dsn){
        RegRead, uid, % OdbcReg.baseKey, % OdbcReg.subkey dsn, UID
        RegRead, pwd, % OdbcReg.baseKey, % OdbcReg.subkey dsn, PWD
        return { dsn: dsn, uid: uid, pwd: pwd }
    }

    load(){

        RegRead, defaultDsn,   % this.baseKey, % OdbcReg.subkey, defaultDsn
        RegRead, defaultOwner, % this.baseKey, % OdbcReg.subkey, defaultOwner
        OdbcReg.default.dsn   := Core.firstValid( defaultDsn   )
        OdbcReg.default.owner := Core.firstValid( defaultOwner )

        OdbcReg.loadDsnList()
        if (defaultDsn){
            if (Core.find(OdbcReg.dsnList, defaultDsn)){
                return OdbcReg.loadDsn(defaultDsn)
            }
        }
        return ""
    }

    loadDsnList(){

        s := ""
        l := {}

        baseKey := OdbcReg.baseKey
        subKey  := OdbcReg.subKey "ODBC Data Sources"

        // I use the built-in sort
        Loop, %baseKey%, %subKey%
        {
            s .= ( s ? "," : "") . a_loopregname
        }

        Sort, s, CLd,
        Loop, parse, s, CSV
        {
            l[A_index] := A_loopfield
        }

        OdbcReg.dsnList := l

        return l
    }

    save( dsn, uid, pwd, defaultDsn = 0, defaultOwner = 0){

        baseKey := OdbcReg.baseKey
        subKey  := OdbcReg.subKey 
        RegWrite, REG_SZ, % baseKey, % subKey dsn, UID, % uid
        RegWrite, REG_SZ, % baseKey, % subKey dsn, PWD, % pwd
        if (defaultDsn) {
            OdbcReg.default.dsn := defaultDsn
            RegWrite, REG_SZ, % baseKey, % subKey, defaultDsn,   % OdbcReg.default.dsn
        }

        if (defaultOwner) {
            OdbcReg.default.owner := defaultOwner
            RegWrite, REG_SZ, % baseKey, % subKey, defaultOwner, % OdbcReg.default.owner
        }



    }

}

