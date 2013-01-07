; Represents any string variable
class String {

    __new(){
        "".base.base := String
    }

    is(type){
        if this is %type%
        {
            return 1
        }
        return 0
    }

    ; specialize the "in" function from the OBJ library
    in( hs ){
        if ( isObject(hs)){
            return Obj.in(hs, this)
        }
        return instr(hs, this)
    }

    ; Returns an array of substrings, split when delimiters are found
    ; -   *delimiters*: characters that split the string
    ; -   *omitchars* (opt): characters to be trimmed out at the sides of each substring
    split(delimiters, omitchars = ""){
        o := {}
        s := this
        Loop, Parse, s, % delimiters, % omitchars
        {
            if (trim(a_loopfield) != "" ){
                o.insert( a_loopField )
            }
        }
        return o
    }

    ; Returns the rightmost characters
    right(n){
        stringright, ret, this, n
        return ret
    }

    ; Returns the leftmost characters
    left(n){
        stringleft, ret, this, n
        return ret
    }

    ; Trims the leftmost characters
    lefttrim(n){
        stringtrimleft, ret, this, n
        return ret
    }

    ; Trims the rightmost characters
    rightTrim(n){
        stringtrimright, ret, this, n
        return ret
    }

    ; Wrapper for stringreplace
    replace( from, to = "", times = "A" ){
        StringReplace, s, this, % from, % to, % times
        return s
    }

    ; Returns a substring
    slice(start=1, end=0) {
        if (end){
            StringMid, ret, this, % start, % start - end
        } else {
            StringMid, ret, this, % start
        }
        return ret
    }

    ; Regexp Matching function
    ; -   *regexp*: regexp to be matched
    ; -   *options* (def:"O"): additional options
    match(regexp, options = "O"){
        s := this
        regexmatch(s, options ")" regexp, match)
        return match
    }

    ; Returns a string which is the repetition of the current
    ; -   *times (def: 1)*: times the string has to be repeated
    fill(times = 1){
        v := this
        varsetcapacity(this, times * ( 2 * a_isunicode ) )
        loop, %times%
        {
            if a_isunicode {
                strput(v, &this + (A_index-1)*2, "utf-16")
            } else {
                strput(v, &this + (A_index-1),   "cp0")
            }
        }
        return this
    }

    ; Returns the concatenation of the object values
    join(arr){
        s := ""
        for i in arr {
            s .= (s == "" ? "" : this ) arr[i]
        }
        return % s
    }

    ; Returns a quoted string
    ; -   *left (def: "'")*: prefix to be added
    ; -   *right (opt)*: suffix. If omitted, the prefix is taken
    q( left="'", right="" ) {
        if (left && !right)
            right := left
        return % left this right
    }

    ; Returns a doublequoted string
    qq(){
        return % this.q("""")
    }

    ; Returns an angled-bracketed string
    qa(){
        return this.q("<", ">")
    }

    ; Returns a bracketed string
    qb(){
        return this.q("(", ")")
    }

    ; Returns a curly-bracketed string
    qc(){ ; curly
        return this.q("{","}")
    }

    ; Returns the uppercase version of the string
    toUpper(){
        stringupper, this, this
        return % this
    }

    ; Returns the lowercase version of the string
    toLower(){
        stringlower, this, this
        return this
    }

    ; Returns a formatted string (Sprintf-like)
    fmt(args*){

        s := this

        ret    := ""
        cursor := 1

        ; build the parse tree
        tree   := this.parse(s)

        ; cycle on it
        for i in tree{

            ; take token
            token := tree[i]

            ; if string, take it as it is
            if (!isobject(token)){
                arg := token

            ; if symbol
            } else {

                ; if positional symbol, take the right argument
                if (token.positional){
                    arg := args[token.positional]
                } else if (token.named){
                    arg := args[token.named]
                } else {
                    arg := args[cursor]
                    cursor += 1
                }

                ; Format arg with symbol specifications
                case := token.symbol
                arg  := ( case == "b" ? (arg ? "true" : "false" )
                      : ( case == "c" ? chr(arg)
                      : ( case == "d" ? floor(arg)
                      : ( case == "e" ? 0 ; exponential not implemented
                      : ( case == "f" ? round(arg, token.precision)
                      : ( case == "o" ? Math.oct(arg)
                      : ( case == "O" ? arg.toString()
                      : ( case == "s" ? ((arg == trim(arg)) && token.precision ? arg.slice(1,token.precision) : arg )
                      : ( case == "u" ? abs(arg)
                      : ( case == "x" ? Math.hex(arg).tolower()
                      : ( case == "X" ? Math.hex(arg)
                : "" )))))))))))

                ; if it is a number, take care about the sign
                if ( token.symbol.match("[defouxX]")){
                    if (arg > 0){
                        sign := (token.signed ? "+" : "")
                    } else {
                        sign := (arg < 0  ? "-" : "")
                    }
                    arg  := (sign ? abs(arg) : arg )
                }

                ; padding, zero
                pad_character := ( strlen(token.zeroed) ? "0" : " " )
                pad_length    := token.width - strlen(arg) - strlen(sign)
                pad           := ( pad_length > 0 && token.width ? pad_character.fill(pad_length) : "" )

                ; width, padding, alignment
                if (token.leftaligned){
                    arg := arg pad
                    arg := arg.slice(strlen(arg) - token.width)
                } else {
                    arg := pad arg
                    arg := arg.slice(1,token.width)
                }
                arg := sign arg
            }
            ret := ret arg

        }
        return % ret
    }

    ; Returns the parse-tree. Internal use for fmt()
    parse(s){

        backup  := s
        ret     := {}
        argType := { positional: 0, named: 0 }

        while s {

            ; match strings
            if (m := s.match("^([^%]+)"))  {
                ret.insert(m[1])

            ; match literal percent symbols
            } else if m := s.match("^%%") {
                ret.insert("%")

            ; match symbols
            } else if m := s.match( ""
                . "^%(?:(?:"
                .   "(?P<positional>\d+)" "|"
                .   "(?P<named>\w+)"
                . ")\$)?"
                . "(?P<signed>\+)?"
                . "(?P<zeroed>0)?"
                . "(?P<leftaligned>-)?"
                . "(?P<width>\d+)?"
                . "(?:\.(?P<precision>\d+))?"
                . "(?P<symbol>[bcdefoOsuxX])"
             . "" ){
                ; avoid mixing positional/type_based arguments 
                argType.positional += (m["positional"] ? 1 : 0)
                argType.named      += (m["named"]      ? 1 : 0)
                if (argType.positional & argType.type_based){
                    throw "Cannot mix positional and type_based tokens. Non implemented yet."
                }

                ; insert token
                ret.insert(m)

            ; no match
            } else {
                throw "Unknown token: " s
            }

            ; remove the match from the string
            stringtrimleft, s,s, m.len(0)

        }

        return ret
    }
}

