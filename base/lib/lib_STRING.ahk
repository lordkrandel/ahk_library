#include <LIB_CORE>

;; Represents any string variable
class String {

    ;; Logical or
    or(a_other){
        if (this){
            return this
        }
        return a_other
    }

    ;; Logical and
    and(a_other){
        if (this && a_other){
            return a_other
        }
        return 
    }    
    
    ;; Returns the string length
    len(){
        return Strlen(this)
    }

    ;; returns 1 if var has the given type
    is(a_type){
        if this is %a_type%
        {
            return 1
        }
        return 0
    }

    ;; Returns the first position of an element
    in(a_haystack){
        if isobject(a_haystack){
            for k, v in a_haystack {
                if ( v == this ){
                    return k
                }
            }
        } 
        return instr(a_haystack, this)
    }    
    
    ;; Returns an array of substrings, split when delimiters are found
    ;; -   *delimiters*: characters that split the string
    ;; -   *omitchars* (opt): characters to be trimmed out at the sides of each substring
    split(a_delimiters=",", a_omitchars = ""){
        l_ret := {}
        l_s := this
        Loop, Parse, l_s, % a_delimiters, % a_omitchars
        {
            if (trim(a_loopfield) != "" ){
                l_ret.insert( a_loopField )
            }
        }
        return l_ret
    }

    ;; Returns the rightmost characters
    right(a_n){
        stringright, l_ret, this, a_n
        return l_ret
    }

    ;; Returns the leftmost characters
    left(a_n){
        stringleft, l_ret, this, a_n
        return l_ret
    }

    ;; Trims the leftmost characters
    lefttrim(a_n){
        stringtrimleft, l_ret, this, a_n
        return l_ret
    }

    ;; Trims the rightmost characters
    rightTrim(a_n){
        stringtrimright, l_ret, this, a_n
        return l_ret
    }

    ;; Wrapper for stringreplace
    replace( a_from, a_to = "", a_times = "A" ){
        StringReplace, l_ret, this, % a_from, % a_to, % a_times
        return l_ret
    }

    ;; Returns a substring
    slice(a_start=1, a_end=0) {
        if (a_end){
            StringMid, l_ret, this, % a_start, % a_end - a_start + 1
        } else {
            StringMid, l_ret, this, % a_start
        }
        return l_ret
    }

    ;; Regexp Matching function
    ;; -   *regexp*: regexp to be matched
    ;; -   *options* (def:"O"): additional options
    match(a_regexp, a_options = "O"){
        regexmatch(this, a_options ")" a_regexp, l_ret)
        return l_ret
    }

    ;; Returns a string which is the repetition of the current
    ;; -   *times (def: 1)*: times the string has to be repeated
    fill(a_times = 1){
        l_ret := ""
        loop, % a_times
        {
            l_ret .= this
        }
        return l_ret
    }

    ;; Returns a quoted string
    q( a_left="'", a_right="" ) {
        if (a_left && !a_right)
            a_right := a_left
        return % a_left this a_right
    }

    ;; Returns a doublequoted string
    qq(){
        return % this.q("""")
    }

    ;; Returns an angled-bracketed string
    qa(){
        return this.q("<", ">")
    }

    ;; Returns a bracketed string
    qb(){
        return this.q("(", ")")
    }

    ;; Returns a curly-bracketed string
    qc(){ 
        return this.q("{","}")
    }

    ;; Returns the uppercase version of the string
    toUpper(){
        stringupper, this, this
        return % this
    }

    ;; Returns the lowercase version of the string
    toLower(){
        stringlower, this, this
        return this
    }

    ;: Returns a formatted string (Sprintf-like)
    fmt(a_params*){

        l_cursor := 1

        ; build the parse tree
        l_tree := this._parse(this)

        ; cycle on it
        for i in l_tree{

            ; take token
            l_token := l_tree[i]

            ; if string, take it as it is
            if (!isobject(l_token)){
                l_arg := l_token

            ; if symbol
            } else {

                ; if positional symbol, take the right argument
                if (l_token.positional){
                    l_arg := a_params[l_token.positional]
                } else if (l_token.named){
                    l_arg := a_params[l_token.named]
                } else {
                    l_arg := a_params[l_cursor]
                    l_cursor += 1
                }

                ; Format arg with symbol specifications
                case := l_token.symbol
                l_arg  := ( case == "b" ? (l_arg ? "true" : "false" )
                      : ( case == "c" ? chr(l_arg)
                      : ( case == "d" ? floor(l_arg)
                      : ( case == "e" ? 0 ; exponential not implemented
                      : ( case == "f" ? round(l_arg, l_token.precision)
                      : ( case == "o" ? Math.oct(l_arg)
                      : ( case == "O" ? l_arg.toString()
                      : ( case == "s" ? ( (l_arg == trim(l_arg)) && l_token.precision 
                                          ? l_arg.slice(1, l_token.precision)
                                          : l_arg )
                      : ( case == "u" ? abs(l_arg)
                      : ( case == "x" ? Math.hex(l_arg).tolower()
                      : ( case == "X" ? Math.hex(l_arg)
                : "" )))))))))))
                
                ; if the precision is dotted, remove the decimal separator
                if (l_token.dot && l_token.precision){
                    l_arg := regexreplace(l_arg, "(\.|,)", "")
                }
                
                ; if it is a number, take care about the sign
                if ( l_token.symbol.match("[defouxX]")){
                    if (l_arg > 0){
                        l_sign := (l_token.signed ? "+" : "")
                    } else {
                        l_sign := (l_arg < 0  ? "-" : "")
                    }
                    l_arg  := (l_sign ? abs(l_arg) : l_arg )
                }

                ; padding, zero
                l_pad_character := ( strlen(l_token.zeroed) ? "0" : " " )
                l_pad_length    := l_token.width - strlen(l_arg) - strlen(l_sign) 
                l_pad           := ( l_pad_length > 0 && l_token.width 
                                   ? l_pad_character.fill(l_pad_length) 
                                   : "" )
                
                ; width, padding, alignment
                if (l_token.leftaligned){
                    l_arg := l_arg l_pad
                    l_arg := l_arg.slice(strlen(l_arg) - l_token.width )
                } else {
                    l_arg := l_pad l_arg
                    l_arg := l_arg.slice(1, l_token.width )
                }
                ; prepend the sign
                l_arg := l_sign l_arg
            }
            ; append the formatted argument
            l_ret := l_ret l_arg

        }
        return l_ret
    }

    ;; Returns the parse-tree. Internal use for fmt()
    _parse(a_s){

        l_ret     := {}
        l_argType := { positional: 0, named: 0 }

        while a_s {

            ; match strings
            if (l_match := a_s.match("^([^%]+)"))  {
                l_ret.insert(l_match[1])

            ; match literal percent symbols
            } else if (l_match := a_s.match("^%%")) {
                l_ret.insert("%")

            ; match symbols
            } else if (l_match := a_s.match( ""
                . "^%(?:(?:"
                .   "(?P<positional>\d+)" "|"
                .   "(?P<named>\w+)"
                . ")\$)?"
                . "(?P<signed>\+)?"
                . "(?P<zeroed>0)?"
                . "(?P<leftaligned>-)?"
                . "(?P<width>\d+)?"
                . "(?:\.(?P<precision>\d+)(?P<dot>\.)?)?"
                . "(?P<symbol>[bcdefoOsuxX])"
             . "" )){

                ; avoid mixing positional/type_based arguments 
                l_argType.positional += (l_match["positional"] ? 1 : 0)
                l_argType.named      += (l_match["named"]      ? 1 : 0)
                if (l_argType.positional & l_argType.type_based){
                    throw "Cannot mix positional and type_based tokens. Non implemented yet."
                }

                ; insert token
                l_ret.insert(l_match)

            ; no match
            } else {
                throw "Unknown token: " a_s
            }

            ; remove the match from the string
            stringtrimleft, a_s, a_s, l_match.len(0)

        }
        return l_ret
    }

    ;; String distance from current to another
    ;; distance(sitting <-> kitten = 3
    ;; Saturday <-> Sunday = 3
    ;; http://en.wikipedia.org/wiki/Levenshtein_distance
    distance(a_1){
        l_len1 := Strlen(a_1)
        l_len2 := Strlen(this)

        ; Build an empty matrix
        l_matrix := []
      
        ; Loop over this string
        Loop, % l_len2 + 1
        {
            ; Build an empty row of the matrix
            l_x := a_index
            l_matrix[l_x] := []

            ; Loop over the other string
            Loop, % l_len1 + 1
            {
                l_y := a_index

                ; The first column and the first row of the matrix
                ; are numbered from 0 to the length of the relative string
                if (l_y == 1){
                    l_matrix[l_x, l_y] := l_x-1
                } else if (l_x == 1){
                    l_matrix[l_x, l_y] := l_y-1

                ; All other cells are calculated on other cells
                } else {
                    lc_1 := substr(a_1,  l_y-1, 1)
                    lc_2 := substr(this, l_x-1, 1)

                    ; Char by char, if the next one is equal in both strings,
                    ; the distance is not increased.
                    if (lc_1 == lc_2){
                        l_matrix[l_x, l_y] := l_matrix[l_x-1, l_y-1]

                    ; Otherwise, the distance is increased by 1
                    ; from the minumum distance found yet
                    } else {
                        l_temp := [ l_matrix[l_x-1, l_y  ]+1
                                  , l_matrix[l_x,   l_y-1]+1
                                  , l_matrix[l_x-1, l_y-1]+1 ]
                        for k, v in l_temp {
                            if (k == 1 || v < l_min){
                                l_min := v
                            }
                        }
                        l_matrix[l_x, l_y] := l_min                                       
                    }
                }
            }
        }
        return l_matrix[l_len2+1, l_len1+1]
    }

}

