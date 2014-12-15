#include <lib_CORE>

global JSON

;; Javascript Json parser class, through OLE
class JSONParser {

    ;; The parser requires a valid JSLint source file as a path
    ;; Javascript code gets read from disk and then interpreted by Windows Scripting Host
    __New(a_path) {
        try{
            l_code := (new File(a_path, "r")).read()
            this.wsh := ComObjCreate("ScriptControl")
            this.wsh.language := "jscript"
            this.wsh.Eval(l_code)
            this.jsonParser := this.wsh.eval("JSON")
        } catch l_exc {
            throw Exception("Error: %s".fmt(l_exc.message))
            this.delete()
        }
    }


    ;; Destructor
    __Delete() {
        ObjRelease(this.wsh)
        ObjRelease(this.jsonParser)
    }

    ;; Load a JSON from disk
    load(a_path, a_reviver=""){
        if (!FileExist(a_path)){
            throw Exception("File " a_path " not found")
        }
        l_content := (new File(a_path, "r")).read()
        return this.parse(l_content, a_reviver)
    }

    ;; Save JSON string to disk
    save(byref a_val, a_name, a_spacer=" "){
        l_serialized := this.stringify(a_val, a_spacer)
        (new File(a_name, "w")).write(l_serialized)
    }

    ;; Parse a json string
    parse(a_json, a_reviver=""){
        try{
            return this.convert( this.jsonParser.parse(a_json, a_reviver) )
        } catch l_exc {
            throw Exception("Error occurred in parsing a JSON string `n" l_exc "`n" a_json )
        }
    }

    ;; Stringify an Autohotkey object
    stringify(a_val, a_spacer=" ", a_precIndent = 0){
        if a_val is number
        {
            l_ret := a_val + 0
        } else if ( isObject(a_val) ) {
            l_obj  := []
            for k, v in a_val {
                l_indent := a_spacer.fill(a_precIndent + 4)
                l_jkey   := k.qq()
                l_jsep   := ": "
                l_jvalue := this.stringify( v, a_spacer, a_precIndent + 4 )
                l_obj.insert( l_indent l_jkey l_jsep l_jvalue )
            }
            l_ret := l_obj.join(",`n")
            l_ret := l_ret.q("`n")
            l_ret := l_ret.q("{", a_spacer.fill(a_precIndent) "}" )
        } else if !(isFunc(a_val)) {
            l_ret := this.quote(a_val)
            l_ret := this.escape(l_ret)
        }
        return l_ret
    }

    ;; Escape backslashes
    escape(a_val){
        return Regexreplace(a_val, "\\", "\\")
    }

    ;; Doublequote the string and escape old doublequotes
    quote(a_val){
        return Regexreplace(a_s, """", "\""").qq()
    }

    ;; Json convert
    convert(a_json) {
        if (!IsObject(a_json)){
            return a_json
        }

        l_properties := a_json.getProperties()
        l_obj := {}
        Loop
        {
            try{
                l_property := l_properties[a_index - 1]
            } catch l_exc {
                break
            }
            l_obj[ l_property ] := this.convert( a_json[ l_property ] )
        }
        return l_obj
    }

}

