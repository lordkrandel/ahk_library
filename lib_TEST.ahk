#include <lib_CORE>

; Tests missing
; =================
; lib_FILE
; lib_MATH
; lib_LOG
; lib_WINDOW
; lib_CALLBACK
; lib_ODBC
; lib_EVENTDISPATCHER
; lib_CLIP
; lib_CONTROL
; lib_LISTBOX
; lib_SOCKET
; lib_WIN32
; lib_G
; lib_G_SINGLESELECT
; lib_CONTROL
; lib_JSON

;; Base class for tests
class TestBase {

    ;; Runs the test
    run(){
        throw Exception(this.__class ".run() called but not implemented")
    }

    ;; Compose the error message
    error(a_s){
        return a_s 
    }

}

;; Test class for String
class StringTest{
    
    ;; check the fmt format result 
    fmt_test(a_format, a_expected, a_params*){
        l_actual := a_format.fmt(a_params*)
        if (l_actual != a_expected)
            throw "fmt_test() format: " a_format " , expected: " a_expected ", actual: " l_actual
        return (l_actual != a_expected)
    }
    
    ;; run the tests
    run(){

        l := 6.777
        StringTest.fmt_test("%09.5.f", "000677700", l)
        StringTest.fmt_test("%09.5f",  "006.77700", l)
        StringTest.fmt_test("%s",      "6.777"    , l)
        StringTest.fmt_test("%8s",     "6.777   " , l)
        StringTest.fmt_test("%-8s",    "   6.777" , l)

        if !("1".is("number") == 1)
            throw Exception("""1"".is(""number"" == 1")
 
        if !("3".in("a4a3") == 4)
            throw Exception("""3"".in(""a4a3"" == 4")

        if !("3".in(["a", "4", "a", "3"]) == 4)
            throw Exception("""3"".in([""a"", ""4"", ""a"", ""3"" == 4")

        if !("3".qq() == """3""")
            throw Exception("""3"".qq( == """"""3"""""" ")

        if !("sunday".distance("saturday") == 3)
            throw Exception("""sunday"".distance(""saturday"" == 3")

    }
}

;; Object base class test class
class ObjectTest extends TestBase {
    testProperty := "testProperty"
    filtertest(k, v){
        return (k < 3)
    }    
    maptest(k, v){
        return v - 1
    }    
    run(){       
        l_ret := [1,2,3,5].values().filter("ObjectTest.filtertest").join("|")
        if !(l_ret == "1|2"){
            throw Exception(""
                . "[1,2,3,5].values().filter(""ObjectTest.filtertest"").join(""|"") == ""1|2""")
        }
        l_ret := [1,2,3,4].map("ObjectTest.maptest").join("|")
        if !(l_ret == "0|1|2|3"){
            throw Exception(""
                . "[1,2,3,4].map(""ObjectTest.maptest"").join(""|"") == ""0|1|2|3""")
        }
        l_ret := [3,4,2,1].min()
        if !(l_ret == 1){
            throw Exception("[3,4,2,1].min() == 1")
        }
        l_ret := [3,4,2,1].max()
        if !(l_ret == 4){
            throw Exception("[3,4,2,1].max() == 4")
        }
        
        if !(this.testProperty == "testProperty"){
            throw Exception("testProperty could not be read")
        }
    }
}

;; Control test class
class ControlTest extends TestBase {
}

;; OdbcSettings test class
class OdbcSettingsTest extends TestBase {

    ;; Run the test
    run(){
    
        l_settings := new OdbcSettings("myDSN", "myUID", "myPWD", "myOWNER")
        l_expected := "dsn=myDSN;uid=myUID;pwd=myPWD;"
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

;; OdbcReg test class
class OdbcRegTest extends TestBase {

    ;; Run the test
    run(){
        
        l_dsn   := "dsnValue2"
        l_uid   := "uidValue"
        l_pwd   := "pwdValue"
        l_owner := "ownerValue"
        l_defaultDriver := "SQL Anywhere 16"

        l_settings := new OdbcSettings(l_dsn, l_uid, l_pwd, l_owner)
        OdbcReg.saveDsn(l_settings, l_defaultDriver)
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

    }
}

;; Test for the Window class
class WindowTest extends TestBase {
    ;; Runs the test
    run(){
        SetTitleMatchMode, 2
        Run, cmd.exe
        Sleep, 200
        l_notepad := new Window("cmd")
        try{
            l_notepad.geom := {x: 200, y: 200}
            Sleep, 100
            l_geom := l_notepad.geom
            if (l_geom["x"] != 200){
                throw Exception("l_geom.x != 200")
            }
        } catch e {
            throw e 
        } finally {
            WinClose, % l_notepad.hwnd_string
        }
    }
}

;; File class tests
class FileTest extends TestBase {
    ;; Runs the test
    run(){
       ;; XXX: Incomplete
    }
}

;; Class to run all tests
class TestRunner {
    ;; Runs all tests
    run(){
        try {
            Core.init()
            (new StringTest()).run()
            (new ObjectTest()).run()
            (new WindowTest()).run()
            (new OdbcSettingsTest()).run()
            (new OdbcRegTest()).run()
            (new FileTest()).run()
            ;(new ControlTest()).run()
            Msgbox, % "Tests successful"
        } catch e {
            Msgbox, 48, % "Test failed"
                , % "[" e.what "()::" e.line (e.extra ? " " e.extra : "") "] `n`n" e.message  
        } finally {
            ExitApp
        }
    }

}

