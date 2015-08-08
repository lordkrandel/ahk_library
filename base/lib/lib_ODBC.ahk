#include <LIB_CORE>

;; ODBC Settings data structure class
class OdbcSettings extends ObjectBase {

    ;; Constructor
    __new(a_dsn, a_uid, a_pwd, a_owner="") {
        this.dsn   := a_dsn
        this.uid   := a_uid
        this.pwd   := a_pwd      
        this.owner := a_owner
    }

    ;; Get all members
    get(byref a_dsn, byref a_uid, byref a_pwd, byref a_owner="") {
        a_dsn   := this.dsn
        a_uid   := this.uid
        a_pwd   := this.pwd
        a_owner := this.owner
    }

    ;; Builds the connectString
    connstring() {
        return "dsn=%s;uid=%s;pwd=%s;".fmt(this.dsn, this.uid, this.pwd)    
    }

}

class SQLiteOdbcSettings extends OdbcSettings {

    ;; Constructor
    __new(a_filename="db.sqlite") {
        this.filename := a_filename
    }

    get(byref a_dsn, byref a_uid, byref a_pwd, byref a_owner="") {
        throw Exception("Disabled")
    }

    ;; Builds the connectString
    connstring() {
        return "Driver=SQLite3 ODBC Driver;Database=%s;".fmt(this.filename)
    }

    
}


;; Models an ODBC connection
class ODBC extends ObjectBase {

    ;; Constructor
    __new( a_params*) {
        l_count := a_params.maxIndex() 
        if (l_count == 0){
            this.settings := OdbcReg.load()
        } else if (l_count == 1){
            this.settings := a_params[1]
        } else if (l_count == 2 || l_count == 3){
            this.settings := new OdbcSettings(a_params[1], a_params[2], a_params[3])
        }
        this.dsnList := OdbcReg.loadDsnList()
    }

    ;; Destructor
    __delete() {
        this.reset()
    }

    ;; Close the connection and reset the object
    reset() {
        this.conn.close()
        this.conn := ""
        this.connected := 0
    }

    ;; Start a new connection
    connect() {
    
        try {
            if (this.connected) {
                this.reset()
            }
            
            this.conn := ComObjCreate("ADODB.Connection")
            this.conn.ConnectionString := this.settings.connstring()
            this.conn.Open()
            this.connected := 1
            return this

        } catch l_exc {
            l_msg := "Cannot connect to database`n`n" "Connstring: `n%s`n`n" "Error:`n%s"
            l_msg := l_msg.fmt( this.settings.connstring(), l_exc.message) 
            throw Exception(l_msg)
        }
    }

    ;; Execute a DDL statement
    statement(a_sql){
        this.conn.execute(a_sql)
    }

}

;; Utility class to retrieve or store ODBC information inside the registry 
class OdbcReg extends ObjectBase {

    static basekey    := "HKEY_LOCAL_MACHINE"
    static subKey     := "SOFTWARE\ODBC\ODBC.INI\"
    static sourcesKey := "ODBC Data Sources"
    static dsnList    := ""

    ;; Load settings from a specific DSN
    loadDsn(a_dsn) {
        l_dsn_key := OdbcReg.subkey 
        try {
            l_uid := OdbcReg.read(a_dsn, "UID")
            l_pwd := OdbcReg.read(a_dsn, "PWD")
        } catch l_exc {
            throw Exception("Cannot read DSN key " a_dsn " from the registry")
        }
        
        try {
            l_owner := OdbcReg.read(a_dsn, "owner")
        } catch l_exc {
            ; do nothing, no owner
        }
        return new OdbcSettings(a_dsn, l_uid, l_pwd, l_owner)
    }

    ;; Read from the ODBC keys of the registry
    ;; read(a_valuename)
    ;; read(a_subkey, a_valuename)        
    read( a_1, a_2="" ) {
        l_valuename := (a_2 ? a_2 : a_1)
        l_subkey    := (a_2 ? a_1 : "")

        ; actually read from the registry
        regread, l_ret, % OdbcReg.basekey, % OdbcReg.subkey l_subkey, % l_valuename
        return l_ret
    }

    ;; Write to the ODBC keys of the registry
    ;; write(a_valuename, a_value)
    ;; write(a_subkey, a_valuename, a_value)
    write( a_1, a_2, a_3="" ) {
        l_value     := (a_3 ? a_3 : a_2)
        l_valuename := (a_3 ? a_2 : a_1)
        l_subkey    := (a_3 ? a_1 : "")
        
        ; actually write to the registry
        RegWrite, REG_SZ, % OdbcReg.basekey, % OdbcReg.subkey l_subkey, % l_valuename, % l_value
    }

    ;; Load settings from the default DSN saved in the registry
    load() {

        ; Read from the registry
        l_defaultDsn :=  OdbcReg.read("dsn")
        OdbcReg.defaultDsn := l_defaultDsn
        
        ; If there actually is a valid default Dsn, load the default settings
        l_dsnlist := OdbcReg.loadDsnList()
        if (l_defaultDsn && l_defaultDsn.in(l_dsnlist)) {
            return OdbcReg.loadDsn(l_defaultDsn)
        }
        
        ; Not found, return nothing
        return
    }

    ;; Load the list of System DSNs from the registry
    loadDsnList() {

        l_ret := {}
        l_baseKey := OdbcReg.baseKey 
        l_subKey  := OdbcReg.subKey OdbcReg.sourcesKey
        
        ; Get all the subkeys
        Loop, % l_baseKey, % l_subKey, 1, 1
        {
            l_s .= ( l_s ? "," : "") A_loopregname
        }

        ; Sort case-insensitive based on locale, delimiter is comma
        Sort, l_s, CLd,
        
        ; Put all the entries into one array
        Loop, parse, l_s, CSV
        {
            l_ret[A_index] := A_loopfield
        }

        ; Save and return the list
        OdbcReg.dsnList := l_ret
        return l_ret
    }

    ;; Save default dsn and owner into the registry
    saveDsn( a_settings, a_default="", a_driver="___" ) {

        l_source := OdbcReg.subKey OdbcReg.sourcesKey
        l_found := 0
        Loop, % OdbcReg.baseKey, % l_source
        {
            if (A_LoopRegName == a_settings.dsn){
                l_found := 1
            }
        }
        if !(l_found){
            OdbcReg.write(OdbcReg.sourcesKey, a_settings.dsn, a_driver)
        }

        ; Save the dsn information
        if (a_default){
            OdbcReg.write("dsn", a_default)
        }
        OdbcReg.write(a_settings.dsn, "UID", a_settings.uid)
        OdbcReg.write(a_settings.dsn, "PWD", a_settings.pwd)
        OdbcReg.write(a_settings.dsn, "owner", a_settings.owner)
    }

}
