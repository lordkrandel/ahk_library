lordkrandel/ahk_library
================================


An Autohotkey_L [http://l.autohotkey.net/] stand-alone library
AHK_L has Object Oriented design, but very few object are included in the core.

Included
---------------------------

    lib_CORE.ahk            // Common functions
    lib_STRING.ahk          // string manipulation
    lib_MATH.ahk            // math, algebra, base change
    lib_LOG.ahk             // logging
    lib_JSON.ahk            // JSON parser ( requires valid json2.js source file )
                            // [https://github.com/douglascrockford/JSON-js]
    lib_G.ahk               // GUI classes library
    lib_GUI.ahk             // External windows handling (stub)
    lib_EVENTDISPATHCER.ahk // GUI events Object Oriented handling
    lib_ODBC.ahk            // Database connection library
    lib_SYNK.ahk            // Utility for building auto-updating programs
    lib_TRAYTIP.ahk         // Simple traytip library

Examples
------------------------

    #include lib\lib_CORE.ahk
    #include lib\\lib_G.ahk


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
               , geom:     { w : 400, h: 240  }
               , hotkeys:  { "F2"      : "f2slot" }   // Defining callbacks for hotkeys
               , controls: { "Button1" : "close"  } } // Defining callbacks for control g-labels

        __new(){
            global t
            g := this.win.name

            // Print the results of the tests
            Gui, %g%: Add, text,    x10 y10, % "\n\n".join(["Test Results:", "\n".join(t), "Press F2 for window info"])
            Gui, %g%: Add, Button,  x280 y200 w100 h25 gEventDispatcher, Close
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

    }

    // Create and show the window
    ( new SampleWindow() ).show()


License: Modified 3-clauses BSD
-------------------------

Copyright (c) 2012, Paolo Gatti, all rights reserved.
https://github.com/lordkrandel/ahk_library

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the organization nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Paolo Gatti ``AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

