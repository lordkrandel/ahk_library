#include lib\\lib_STRING.ahk

class JSONParser {

    // The parser requires a valid JSLint source file as a path
    __New(jsParserPath) {
        try{
            jsParserText := fileopen( jsParserPath, "r").read()
            this.wsh := ComObjCreate("ScriptControl")
            this.wsh.language := "jscript"
            this.wsh.Eval( jsParserText )
            this.jsonParser := this.wsh.eval("JSON")
        } catch e {
            throw e
            this.delete()
        }
    }

    fromFile( path, reviver="" ){
        s := fileOpen( path, "r").read()
        return this.parse( s, reviver )
    }

    parse(jsonString, reviver="" ){
        try{
            return this.convert( this.jsonParser.parse(jsonString, reviver) )
        } catch e{
            throw e
        }
    }

    stringify(val, spacer = " ", precIndent = 0){
        if val is number
        {
            s := val + 0
        } else if ( isObject(val) ) {
            o := []
            for k,v in val {
                indent := spacer.fill(precIndent + 4)
                jkey   := k.qq()
                jsep   := ": "
                jvalue := this.stringify( v, spacer, precIndent + 4 )
                o.insert( indent jkey jsep jvalue )
            }
            s := ",\n".join(o)
            s := s.q("\n")
            s := s.q("{", spacer.fill(precIndent) "}" )
        } else if ( ! isFunc(val) ) {
            s := this.quote(val)
        }
        return s
    }

    quote(val){
        return Regexreplace(val, """", "\\""").qq()
    }

    convert(j) {

        if (!IsObject(j)){
            return j
        }

        r := j.getProperties()
        o := {}
        Loop
        {
            try{
                p := r[a_index - 1]
            } catch e {
                break
            }
            o[ p ] := this.convert( j[ p ] )
        }
        return o

    }

    __Delete() {
        ObjRelease(this.wsh)
        ObjRelease(this.jsonParser)
    }

    save( byref value, filename, replacer="", space=4){
        s := this.stringify(value)
        fileOpen(filename, "w").write(s)
    }

}

