
#include lib\lib_CORE.ahk
#include lib\\lib_G.ahk
#include lib\\lib_GUI.ahk
#include lib\\lib_JSON.ahk

t:= {}

// Math examples ___________________________

o := [ 1, 3, 6, 64, -3 ]

// Min, Max
t.insert( Math.max(o) ", " Math.min(o) )

// First Valid
t.insert( Core.firstValid( 0, "", "abba", 5 ) )

// Hex functions
t.insert( Math.hex(133) )
t.insert( Math.fromHex(85) )

// Xor
fruits := { "Pear" : 5, "Orange" : 10 }
if ( Math.xor( fruits["Pear"], fruits["Strawberry"] ) ) {
    t.insert( "There are Pears but no Strawberries" )
}



// String examples _________________________

// Split
s := "Purple,Brown,Green,Red,Yellow"
o := s.split(",")

p := {}
for k,v in o {
    // Quote each element
    p.insert(k,v.q())
}

// Fmt ( sprintf ), Join, Quote with ()
t.insert( "SELECT * FROM fruit WHERE color in %s;".fmt( ",".join(p).qb() ) )

// Right, righttrim, toUpper
t.insert( "abcdefghijklmnopqrstuvxyz".right(4).righttrim(2).toUpper() )



// G examples ______________________________

class SampleWindow extends g {

    win := { name:     "Example"
           , title:    "sampleWindow"
           , geom:     { w : 400, h: 240         }
           , hotkeys:  { "F2"      : "f2slot"    }   // Defining callbacks for hotkeys
           , controls: { "Button1" : "close"
                       , "Button2" : "JSONtest"  } } // Defining callbacks for control g-labels

    __new(){
        global t
        g := this.win.name

        // Print the results of the tests
        Gui, %g%: Add, text,    x10 y10, % "\n\n".join(["Test Results:", "\n".join(t), "Press F2 for window info"])
        Gui, %g%: Add, Button,  x280 y200 w100 h25 gEventDispatcher, Close
        Gui, %g%: Add, Button,  x180 y200 w100 h25 gEventDispatcher, JSON Test
    }

    f2slot(){
        // When F2 is pressed
        Msgbox, % "You just pressed F2"
                . "\n\n" "title: " this.win.title
                . "\n"   "x: "     this.geom.x
                . "\n"   "y: "     this.geom.y
                . "\n"   "w: "     this.geom.w
                . "\n"   "h: "     this.geom.h
    }

    close(){
        // On close
        base.close()
        ExitApp
    }

    JSONtest(){

        // JSON and GUI examples ___________________________
        id    := this.win.hwnd
        j     := new JSONParser("json.js")
        ctrls := Gui.getControls(id)
        Msgbox, % j.stringify(ctrls)

    }

}

// Create and show the window
dw := new SampleWindow()
dw.show()
















