;; OdbcSettings test class
class OdbcSettingsTest extends TestBase {

    ;; Run the test
    run(){

        ; Test the OdbcSettings data structure
        l_settings := new OdbcSettings("myDSN", "myUID", "myPWD", "myOWNER")
        l_expected := "dsn=myDSN;uid=myUID;pwd=myPWD;"

        ; Check if the connstring() is well formed
        if !(l_settings.connstring() == l_expected)
            throw Exception("l_settings.connstring() == " l_expected ) 

        l_settings.get(l_dsn, l_uid, l_pwd, l_owner)
        if !(l_dsn == "myDSN")
            throw Exception("l_dsn == ""myDSN""")
        if !(l_uid == "myUID")
            throw Exception("l_uid == ""myUID""")
        if !(l_pwd == "myPWD")
            throw Exception("l_pwd == ""myPWD""")
        if !(l_owner == "myOWNER")
            throw Exception("l_owner == ""myOWNER""")
    }
}