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