;; OdbcReg test class
class OdbcRegTest extends TestBase {

    ;; Run the test
    run(){
        
        l_dsn   := "dsnValue"
        l_uid   := "uidValue"
        l_pwd   := "pwdValue"
        l_owner := "ownerValue"
        l_defaultDriver := "SQL Anywhere 16"

        ; Save a fake DSN in the registry
        l_settings := new OdbcSettings(l_dsn, l_uid, l_pwd, l_owner)
        OdbcReg.saveDsn(l_settings, l_defaultDriver)

        ; Retrieve that fake DSN from the registry
        l_settings := OdbcReg.loadDsn(l_dsn)

        ;; XXX: also test for OdbcReg.loadDsn(a_dsn) failure 
        if !(l_settings.dsn == l_dsn)
            throw Exception("l_settings_ret.dsn == l_dsn")
        if !(l_settings.uid == l_uid)
            throw Exception("l_settings_ret.uid == l_uid")
            if !(l_settings.pwd == l_pwd)
            throw Exception("l_settings_ret.pwd == l_pwd")
        if !(l_settings.owner == l_owner)
            throw Exception("l_settings_ret.owner == l_owner")

        ; XXX: remove the fake DSN from the registry
    }

}