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