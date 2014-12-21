;; SQL basic formatter and more
class SQLFormatter extends ObjectBase {

    ;; apply cleanup on selection
    formatSelection(){
        l_text := Clip.copy()
        l_text := SQLFormatter (l_text)
        Clip.paste(l_text)
    }

    ;; cleanup a query with a regex series
    format(a_text){
        l_regexes := { ""
            . """"                                                  : ""               ; doublequotes
            , "\s*(,)\s*"                                           : ",`r`n"          ; commas
            , "\s+(AND|OR)\s+"                                      : "`r`n $1"        ; AND|OR
            , "\s+(SELECT|FROM|WHERE|GROUP BY|HAVING|ORDER BY)\s+"  : "`r`n$1 `r`n`t"  ; SQL TOKENS
            , "^[ ]+"                                               : " "              ; trim spaces
            , "\s+;"                                                : "`r`n`r`n;"      ; semicolon
            . "" }
    
        ; Apply RegExReplaces case-insensitively
        for l_from, l_to in l_regexes {
            a_text := RegExReplace(a_text, "i)" l_from, l_to)
        }
        return a_text
    }
    
}
