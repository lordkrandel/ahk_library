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