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