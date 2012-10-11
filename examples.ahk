
#include <lib_CORE>
#include <lib_G>
#include <lib_JSON>
#include <lib_SOCKET>
Core.init()


t:= {}

; Math examples

o := [ 1, 3, 6, 64, -3 ]

; Min, Max
t.insert( Math.max(o) ", " Math.min(o) )

; First Valid
t.insert( Core.firstValid( 0, "", "abba", 5 ) )

; Hex functions
t.insert( Math.hex(133) )
t.insert( Math.fromHex(85) )

; Xor
fruits := { "Pear" : 5, "Orange" : 10 }
if ( Math.xor( fruits["Pear"], fruits["Strawberry"] ) ) {
    t.insert( "There are Pears but no Strawberries" )
}



; String examples

; Split
s := "Purple,Brown,Green,Red,Yellow"
o := s.split(",")

p := {}
for k,v in o {
    ; Quote each element
    p.insert(k,v.q())
}

; Fmt ( sprintf ), Join, Quote with ()
t.insert( "SELECT * FROM fruit WHERE color in %s;".fmt( ",".join(p).qb() ) )

; Right, righttrim, toUpper
t.insert( "abcdefghijklmnopqrstuvxyz".right(4).righttrim(2).toUpper() )



; Object examples

numbers := [0,1,2,3,4,5]

; map
twice := Obj.map(numbers, "multiply")
thrice := Obj.map(numbers, Func("multiply"), 3)

multiply(val, p = 2)
{
	return val * p
}

; filter
odds := Obj.filter(numbers, "odd")

odd(key, val)
{
	return val & 1
}

; values
children := { "Frank" : 17, "John" : 3, "Sara" : 17 }
ages := Obj.values(children)

; for display only
j := new JSONParser(A_ScriptDir "\json.js")
t.insert(j.stringify(twice).replace("`n"))
t.insert(j.stringify(thrice).replace("`n"))
t.insert(j.stringify(odds).replace("`n"))
t.insert(j.stringify(ages).replace("`n"))


; G examples

class SampleWindow extends g {

    name  := "Example"
    title := "sampleWindow"
    geom  := { w : 400, h: 240 }
    win := { hotkeys:  { "F2"      : "f2slot"      }   ; Defining callbacks for hotkeys
           , controls: { "Button1" : "close"
                       , "Button2" : "JSONtest"
                       , "Button3" : "SOCKETtest"  } } ; Defining callbacks for control g-labels

    __new(){
        global t
        g := this.name

        ; Print the results of the tests
        Gui, %g%: Add, text,    x10 y10, % "`n`n".join(["Test Results:", "`n".join(t), "Press F2 for window info"])
        Gui, %g%: Add, Button,  x80  y200 w100 h25 gEventDispatcher, Close
        Gui, %g%: Add, Button,  x180 y200 w100 h25 gEventDispatcher, JSON Test
        Gui, %g%: Add, Button,  x280 y200 w100 h25 gEventDispatcher, Socket Send Test
    }

    f2slot(){
        ; When F2 is pressed
        Msgbox, % "You just pressed F2`n"
                . "`n" "title: " this.title
                . "`n" Window.geomToString( this.geom )
    }
    close(){
        ; On close
        base.close()
        ExitApp
    }

    SOCKETtest(){
        s := new Socket("127.0.0.1", 18664)
        s.send("hi!")
        ; s.receive()

        ; Python test as a server
        ; import socket, time
        ; host    = '127.0.0.1'
        ; port    = 18664
        ; backlog = 5
        ; size    = 1024
        ; s       = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
        ; # s.setblocking(True)
        ; s.bind( (host,port) )
        ; s.listen(backlog)
        ; client, address = s.accept()
        ; while 1:
        ;     data = client.recv(size)
        ;     if data:
        ;         # AHK_L Unicode
        ;         print(data.decode('utf-16LE'))
        ;         time.sleep(1)
        ;         client.send(data)
        ; #client.close()
    }

    JSONtest(){

        ; JSON and GUI examples
        id    := this.hwnd
        j     := new JSONParser("json.js")
        o := {}
        for k, v in new Window( this.hwnd ).controls {
            o.insert( k, v.getDescription() )
        }
        Msgbox, % j.stringify(o)

    }

}

; Create and show the window
dw := new SampleWindow()
dw.show()








