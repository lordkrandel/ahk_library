
; put this file in the base folder
; or it won't be able to find the library directory

#include <lib_SOCKET>

s := new Socket("127.0.0.1", 18664)
s.send("hi!")
s.receive()

ExitApp

