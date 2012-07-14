lordkrandel/ahk_library
================================

What
------------------------

An Autohotkey_L [http://l.autohotkey.net/] stand-alone library

The only external requirement is a valid JSON-js [https://github.com/douglascrockford/JSON-js] json2.js javascript source file for the lib_JSON

Start having a look at examples.ahk


Why
------------------------

This is my personal Object-Oriented library I use for AHK_L development.
AHK_L has Object Oriented design, but very few object are included in the core.


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

