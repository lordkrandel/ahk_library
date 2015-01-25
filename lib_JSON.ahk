#include <lib_CORE>

;; Javascript Json parser class, through OLE
class JSON extends ObjectBase {

    ;; The parser requires a valid JSLint source file as a path
    ;; Javascript code gets read from disk and then interpreted by Windows Scripting Host
    __New() {
        try {
            l_code := JSON.code
            this.wsh := ComObjCreate("ScriptControl")
            this.wsh.language := "jscript"
            this.wsh.Eval(JSON.code())
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
    parse(a_json, a_reviver="") {
        try {
            return this.convert(this.jsonParser.parse(a_json, a_reviver))
        } catch l_exc {
            throw Exception("Error occurred in parsing a JSON string `n" l_exc "`n" a_json )
        }
    }

    ;; Stringify an Autohotkey object
    stringify(a_val, a_spacer=" ", a_precIndent=0) {
        if a_val is number
        {
            l_ret := a_val + 0
        } else if ( isObject(a_val) ) {
            l_obj := []
            for k, v in a_val {
                l_indent := a_spacer.fill(a_precIndent + 4)
                l_jkey   := k.qq()
                l_jsep   := ": "
                l_jvalue := this.stringify(v, a_spacer, a_precIndent + 4)
                l_obj.insert(l_indent l_jkey l_jsep l_jvalue)
            }
            l_ret := l_obj.join(",`n")
            l_ret := l_ret.q("`n")
            l_ret := l_ret.q("{", a_spacer.fill(a_precIndent) "}")
        } else {
            l_ret := this.quote(a_val)
            l_ret := this.escape(l_ret)
        }
        return l_ret
    }

    ;; Escape backslashes
    escape(a_val){
        return RegexReplace(a_val, "\\", "\\")
    }

    ;; Doublequote the string and escape old doublequotes
    quote(a_val){
        return RegexReplace(a_val, """", "\""").qq()
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

    code(){
        l_code =
(
    /*
        http://www.JSON.org/json2.js
        2011-10-19
        Public Domain.
        NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
        See http://www.JSON.org/js.html
        This code should be minified before deployment.
        See http://javascript.crockford.com/jsmin.html
        USE YOUR OWN COPY. IT IS EXTREMELY UNWISE TO LOAD CODE FROM SERVERS YOU DO
        NOT CONTROL.
    */
    var JSON;
    if (!JSON) {
        JSON = {};
    }
    (function () {
        'use strict';
        function f(n) {
            return n < 10 ? '0' + n : n;
        }
        if (typeof Date.prototype.toJSON !== 'function') {
            Date.prototype.toJSON = function (key) {
                return isFinite(this.valueOf())
                    ? this.getUTCFullYear()     + '-' +
                        f(this.getUTCMonth() + 1) + '-' +
                        f(this.getUTCDate())      + 'T' +
                        f(this.getUTCHours())     + ':' +
                        f(this.getUTCMinutes())   + ':' +
                        f(this.getUTCSeconds())   + 'Z'
                    : null;
            };
            String.prototype.toJSON      =
                Number.prototype.toJSON  =
                Boolean.prototype.toJSON = function (key) {
                    return this.valueOf();
                };
        }
        var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
            escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
            gap,
            indent,
            meta = {    // table of character substitutions
                '\b': '\\b',
                '\t': '\\t',
                '\n': '\\n',
                '\f': '\\f',
                '\r': '\\r',
                '"' : '\\"',
                '\\': '\\\\'
            },
            rep;
        function quote(string) {
            escapable.lastIndex = 0;
            return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
                var c = meta[a];
                return typeof c === 'string'
                    ? c
                    : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
            }) + '"' : '"' + string + '"';
        }
        function str(key, holder) {
            var i,          // The loop counter.
                k,          // The member key.
                v,          // The member value.
                length,
                mind = gap,
                partial,
                value = holder[key];
            if (value && typeof value === 'object' &&
                    typeof value.toJSON === 'function') {
                value = value.toJSON(key);
            }
            if (typeof rep === 'function') {
                value = rep.call(holder, key, value);
            }
            switch (typeof value) {
            case 'string':
                return quote(value);
            case 'number':
                return isFinite(value) ? String(value) : 'null';
            case 'boolean':
            case 'null':
            case 'date':
                return String(value);
            case 'object':
                if (!value) {
                    return 'null';
                }
                gap += indent;
                partial = [];
                if (Object.prototype.toString.apply(value) === '[object Array]') {
                    length = value.length;
                    for (i = 0; i < length; i += 1) {
                        partial[i] = str(i, value) || 'null';
                    }
                    v = partial.length === 0
                        ? '[]'
                        : gap
                        ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                        : '[' + partial.join(',') + ']';
                    gap = mind;
                    return v;
                }
                if (rep && typeof rep === 'object') {
                    length = rep.length;
                    for (i = 0; i < length; i += 1) {
                        if (typeof rep[i] === 'string') {
                            k = rep[i];
                            v = str(k, value);
                            if (v) {
                                partial.push(quote(k) + (gap ? ': ' : ':') + v);
                            }
                        }
                    }
                } else {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = str(k, value);
                            if (v) {
                                partial.push(quote(k) + (gap ? ': ' : ':') + v);
                            }
                        }
                    }
                }
                v = partial.length === 0
                    ? '{}'
                    : gap
                    ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                    : '{' + partial.join(',') + '}';
                gap = mind;
                return v;
            }
        }
        if (typeof JSON.stringify !== 'function') {
            JSON.stringify = function (value, space, replacer) {
                var i;
                gap = '';
                indent = '';
                if (!space) { space = 4; }
                if (typeof space === 'number') {
                    for (i = 0; i < space; i += 1) {
                        indent += ' ';
                    }
                } else if (typeof space === 'string') {
                    indent = space;
                }
                rep = replacer;
                if (replacer && typeof replacer !== 'function' &&
                        (typeof replacer !== 'object' ||
                        typeof replacer.length !== 'number')) {
                    throw new Error('JSON.stringify');
                }
                return str('', {'': value});
            };
        }
        if (typeof JSON.parse !== 'function') {
            JSON.parse = function (text, reviver) {
                var j;
                function walk(holder, key) {
                    var k, v, value = holder[key];
                    if (value && typeof value === 'object') {
                        for (k in value) {
                            if (Object.prototype.hasOwnProperty.call(value, k)) {
                                v = walk(value, k);
                                if (v !== undefined) {
                                    value[k] = v;
                                } else {
                                    delete value[k];
                                }
                            }
                        }
                    }
                    return reviver.call(holder, key, value);
                }
                text = String(text);
                cx.lastIndex = 0;
                if (cx.test(text)) {
                    text = text.replace(cx, function (a) {
                        return '\\u' +
                            ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                    });
                }
                if (/^[\],:{}\s]*$/
                        .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                            .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                            .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {
                    j = eval('(' + text + ')');
                    j.stringify  = function(space, replace) { return JSON.stringify( this, space, replace); } ;
                    return typeof reviver === 'function'
                        ? walk({'': j}, '')
                        : j;
                }
                throw new SyntaxError('JSON.parse');
            };
        }
    }());
    Object.prototype.getProperties = function(){
        var keys = [];
        for(var key in this){
            if (this.hasOwnProperty(key) && (typeof this[key] !== 'function')) {
               keys.push(key);
            }
        }
        return keys;
    }
    Object.prototype.set = function(name, value){
        return this[name] = value;
    }
    Object.prototype.get = function(name){
        return this[name];
    }
)
        return l_code
    }    
}

