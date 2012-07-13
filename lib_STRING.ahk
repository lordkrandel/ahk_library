
class String {

    // split
    split(delimiters, omitchars){
        o := {}
        s := this
        Loop, Parse, s, % delimiters 
        {
            o.insert( a_loopField )
        }
        return o
    }

    //    strget    //
    strget(offset, len, enc = ""){
        static clen   := 2 * A_isUnicode
             , defEnc := ( A_IsUnicode ? "utf-16" : "CP" )
        if (! enc) {
             enc := defEnc
        }
        return strget( &this + clen * offset, len , enc )
    }

    //    right     //
    right(n){
        stringright, ret, this, n
        return ret
    }

    //    left      //
    left(n){
        stringleft, ret, this, n
        return ret
    }

    //    lefttrim  //
    lefttrim(n){
        stringtrimleft, ret, this, n
        return ret
    }

    //    righttrim //
    rightTrim(n){
        stringtrimright, ret, this, n
        return ret
    }

    //    slice    //
    slice(start=1, end=0) {
        if (end){
            StringMid, ret, this, % start, % start - end
        } else {
            StringMid, ret, this, % start
        }
        return ret
    }

    //    match    //
    match(regexp, options = "O"){
        s := this
        regexmatch(s, options ")" regexp, match)
        return match
    }

    //    fill     //
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

    //    join    //
    join(arr){
        s := ""
        for i in arr {
            s .= (s == "" ? "" : this ) arr[i]
        }
        return % s
    }

    //    q, qq, braq, curlyq   //
    q( left="'", right="" ) {
        if (left && !right)
            right := left
        return % left this right
    }
    qq(){
        return % this.q("""")
    }
    braq(){
        return % this.q("(", ")")
    }
    curlyq(){
        return this.q("{","}")
    }

    //   toUpper, toLower   //
    toUpper(){
        stringupper, this, this
        return % this
    }
    toLower(){
        stringlower, this, this
        return % this
    }

    //     fmt      //
    fmt(args*){

        s := this

        ret    := ""
        cursor := 1

        // build the parse tree
        tree   := this.parse(s)

        // cycle on it
        for i in tree{

            // take token
            token := tree[i]

            // if string, take it as it is
            if (!isobject(token)){
                arg := token

            // if symbol
            } else {

                // if positional symbol, take the right argument
                if (token.positional){
                    arg := args[token.positional]
                } else if (token.named){
                    arg := args[token.named]
                } else {
                    arg := args[cursor]
                    cursor += 1
                }

                // Format arg with symbol specifications
                case := token.symbol
                arg  := ( case == "b" ? (arg ? "true" : "false" )
                      : ( case == "c" ? chr(arg)
                      : ( case == "d" ? floor(arg)
                      : ( case == "e" ? 0 // exponential not implemented
                      : ( case == "f" ? round(arg, token.precision)
                      : ( case == "o" ? Math.oct(arg)
                      : ( case == "O" ? arg.toString()
                      : ( case == "s" ? ((arg == trim(arg)) && token.precision ? arg.slice(1,token.precision) : arg )
                      : ( case == "u" ? abs(arg)
                      : ( case == "x" ? Math.hex(arg).tolower()
                      : ( case == "X" ? Math.hex(arg)
                : "" )))))))))))

                // if is number, take care about the sign
                if ( token.symbol.match("[defouxX]")){
                    if (arg > 0){
                        sign := (token.signed ? "+" : "")
                    } else {
                        sign := (arg < 0  ? "-" : "")
                    }
                    arg  := (sign ? abs(arg) : arg )
                }

                // padding, zero
                pad_character := ( strlen(token.zeroed) ? "0" : " " )
                pad_length    := token.width - strlen(arg) - strlen(sign)
                pad           := ( pad_length > 0 && token.width ? pad_character.fill(pad_length) : "" )

                // width, padding, alignment
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

    // parse //
    parse(s){

        backup  := s
        ret     := {}
        argType := { positional: 0, named: 0 }

        while s {

            // match strings
            if (m := s.match("^([^%]+)"))  {
                ret.insert(m[1])

            // match literal percent symbols
            } else if m := s.match("^%%") {
                ret.insert("%")

            // match symbols
            } else if m := s.match( ""
                . "^%(?:(?:"
                .   "(?P<positional>\\d+)" "|"
                .   "(?P<named>\\w+)"
                . ")\\$)?"
                . "(?P<signed>\\+)?"
                . "(?P<zeroed>0)?"
                . "(?P<leftaligned>-)?"
                . "(?P<width>\\d+)?"
                . "(?:\\.(?P<precision>\\d+))?"
                . "(?P<symbol>[bcdefoOsuxX])"
             . "" ){
                // avoid mixing positional/type_based arguments 
                argType.positional += (m["positional"] ? 1 : 0)
                argType.named      += (m["named"]      ? 1 : 0)
                if (argType.positional & argType.type_based){
                    throw "Cannot mix positional and type_based tokens. Non implemented yet."
                }

                // insert token
                ret.insert(m)

            // no match
            } else {
                throw "Unknown token: " s
            }

            // remove the match from the string
            stringtrimleft, s,s, m.len(0)

        }

        return % ret
    }
}
"".base.base := String

