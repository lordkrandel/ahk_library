#include <lib_CORE>

; Tests missing
; =================
; lib_LOG
; lib_WINDOW
; lib_CALLBACK
; lib_ODBC (query)
; lib_EVENTDISPATCHER
; lib_CLIP
; lib_CONTROL
; lib_LISTBOX
; lib_SOCKET
; lib_G
; lib_G_SINGLESELECT
; lib_JSON

;; Base class for tests
class TestBase {

    ;; Runs the test
    run(){
        throw Exception(this.__class ".run() called but not implemented")
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
        StringTest.fmt_test("%%",      "%"        , l)

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

;; Test for the Window class
class WindowTest extends TestBase {

    ;; Runs the test
    run(){
        SetTitleMatchMode, 2

        ; Create a CMD window
        Run, cmd.exe
        Sleep, 200
        l_notepad := new Window("cmd")

        try{
            ; Try to move it
            l_notepad.geom := {x: 200, y: 200}
            Sleep, 100
            
            ; Try to detect if it correctly moved
            l_geom := l_notepad.geom
            if (l_geom["x"] != 200){
                throw Exception("l_geom.x != 200")
            }
        } catch e {
            throw e 
        } finally {
            ; Close the CMD window when finished
            WinClose, % l_notepad.hwnd_string
        }
    }
}


;; StringAsPathMixin tests
class StringAsPathMixinTest extends TestBase {

    ; XXX: More tests needed

    ;; Runs the test
    run(){
        
        ; Hasfiles test
        l_windir := A_Windir "\*.*"
        if !(l_windir.hasFiles()){
            throw Exception(l_windir ".hasFiles() failed")
        }
        
        l_pattern := "c:\path\to\file.ahk"
        if !(l_pattern.extension() == "ahk"){
            throw Exception(l_pattern.qq() ".extension() failed")
        }
        if !(l_pattern.noextension() == "file"){
            throw Exception(l_pattern.qq() ".noextension() failed" )
        }
        if !(l_pattern.basename() == "file.ahk"){
            throw Exception(l_pattern.qq() ".basename() failed")
        }
        if !(l_pattern.basepath() == "c:\path\to"){
            throw Exception(l_pattern.qq() ".basepath() failed")
        }
    }

}


;; File class tests
class FileTest extends TestBase {

    ;; Runs the test
    run(){

        ; XXX: Unicode tests
    
        l_filename := A_temp "\" A_now ".tmp"
        l_file := new File(l_filename, "w")

        l_text := "TEST"
        try {

            ; Creation test
            if !(FileExist(l_filename)){
                throw Exception("Creation failed.")
            }
            ; Write test
            l_file.Write(l_text)        

            ; Read test
            l_file := ""
            l_file := new File(l_filename, "r")
            l_text_actual := l_file.read()
            if !(l_text == l_text_actual){
                throw Exception("Reading failed.")
            }

            ; Seek test
            l_file.seek(0)            
            l_text_actual := l_file.read()
            if !(l_text == l_text_actual){
                throw Exception("Seek failed.")
            }
            
            ; Tell test
            l_pos := 1
            l_file.position := l_pos
            l_tell := l_file.tell() 
            if !(l_tell == l_pos){
                throw Exception("Tell failed.")
            }            
            if !(l_file.position == l_pos){
                throw Exception("Position failed.")
            }            
            
        } catch l_exc {

            ; Add filename to the exception message
            throw Exception("File: " l_filename ", " l_exc.message)

        } finally {

            ; Close file
            l_file := ""

            ; Delete file
            if (FileExist(l_filename)){
                FileDelete, % l_filename
            }

        }
    }

}

;; StringAsMathMixin test class
class StringAsMathMixinTest extends TestBase {

    ;; Runs all tests
    run(){ 
    
        if !( 0.xor(1) ){
            throw Exception("0.xor(1) == 1 failed")
        }
        if !( (255).hex() == "0xFF"){
            throw Exception("(255).hex() == ""0xFF"" failed")
        }
        if !( (255).oct() == "0x377"){
            throw Exception("(255).oct() == ""0x377"" failed")
        }
        if !( "FF".fromHex() == 255){
            throw Exception("(""FF"").fromHex() == 255 failed")
        }
        if !( (3).between(1,5)){
            throw Exception("(3).between(1,5) failed")
        }
        if !( (7).between(1,5) == 0){
            throw Exception("(7).between(1,5) == 0 failed")
        }

    }

}

;; Win32 API handler class tests
class Win32Test extends TestBase {

    ; XXX: More tests
    
    ;; Runs all tests
    run(){

        l_text := "text"
        l_ret := Win32.CharUpper("str", l_text, "str")
        if !(l_ret && l_ret == l_text.toUpper() ){
            throw Exception("Win32.CharUpper(" l_text.qq() ") == ""text"".toUpper() failed")
        }
 
    }
}

;; Control test class
class ControlTest extends TestBase {
}

;; Class to run all tests
class TestRunner extends TestBase {

    ;; Runs all tests
    run(){

        try {

            l_tests := [ ""
                . StringTest
                , ObjectTest
                , WindowTest
                , OdbcSettingsTest
                , OdbcRegTest
                , FileTest
                , StringAsPathMixinTest 
                , StringAsMathMixinTest
                , Win32Test ]

            for _, l_testclass in l_tests {
                l_test := new l_testclass()
                l_test.run()
            }
            
            Msgbox, % "Tests successful"
            
        } catch e {
            Msgbox, 48
                , % "Test failed"
                , % "[" e.what "()::" e.line (e.extra ? " " e.extra : "") "] `n`n" e.message  
        } finally {
            ExitApp
        }
    }

}

