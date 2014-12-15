#include <LIB_CORE>

;; Base class for all objects and arrays
class ObjectBase {

    ;; Returns all the keys of an object
    keys(){
        if !(isobject(this))
            return
        l_ret := {}
        for k, v in this {
            l_ret.insert(k)
        }
        return l_ret
    }

    ;; returns an (non-associative) array with the values in an object
    values(){
        if !(isobject(this))
            return
        l_ret := {}
        for k, v in this {
            l_ret.insert(v)
        }
        return l_ret
    }

    ; Returns an object with keys and values swapped
    swap(){
        if !(isobject(this))
            return
        l_ret := {}
        for k, v in this {
            l_ret[v] := k
        }
        return l_ret
    }

    ;; Returns the maximum element
    max(){
        if !(isobject(this))
            return
        for k, v in this {
            if (v > l_max){
                l_max := v
            }
        }
        return l_max
    }    

    ;; Returns the minimum element
    min(){
        if !(isobject(this))
            return
        l_count := 0
        for k, v in this {
            l_count := l_count + 1
            if (l_count == 1 || v < l_min){
                l_min := v
            }
        }
        return l_min
    }    

    ;; Returns the first position of an element
    in( val ){
        if !(isobject(this))
            return
        for k, v in this {
            if ( v == val ){
                return A_index
            }
        }
    }    
    
    ;; Returns the first value which is not null, empty or zero
    firstValid(){
        if !(isobject(this))
            return
        for k, v in this {
            if (v) {
                return v
            }
        }
    }
    
    ;; put the element at the end of the array
    push( el ){
        if !(isobject(this))
            return
        return this.insert( el )
    }

    ;; pop out the element at the end of the array
    pop(){
        if !(isobject(this))
            return
        return this.remove()
    }

    ;; shift an element at the start of the array
    shift( el ){
        if !(isobject(this))
            return
        n := [ el ]
        n.insert( this* )
        this := n
        return 1
    }

    ;; unshift an element from the start of the array
    unshift(){
        if !(isobject(this))
            return
        return this.remove( this.MinIndex() )
    }
    
    ;; join all values as strings, separated with sep
    join(a_sep="`n"){
        if !(isobject(this))
            return
        for k, v in this {
            l_ret .= (k > 1 ? a_sep : "" ) v
        }
        return l_ret
    }

    ;; filter with callback function
    filter(callback, params*) {
        if !(isobject(this))
            return
        l_ret := {}
        for k, v in this {
            ; Class static callbacks need the extra this argument
            if (instr(callback, ".")){
                l_check := callback.(this, k, v, params*)
            } else {
                l_check := callback.(k, v, params*)
            }
            if (l_check){
                l_ret[k] := v
            }
        }
        return l_ret
    }

    ;; map all values to a callback function
    map(callback, params*) {
        if !(isobject(this))
            return
        l_ret := {}
        for k, v in this {
            ; Class static callbacks need the extra this argument
            if (instr(callback, ".")){
                l_new := callback.(this, k, v, params*)
            } else {
                l_new := callback.(k, v, params*)
            }
            l_ret[k] := l_new
        }
        return l_ret
    }
    ;; R3gX <http://www.autohotkey.com/board/topic/83081-ahk-l-customizing-object-and-array/>
    remove(a_params*){
        if (a_params.maxIndex() == 1) {
            l_first := a_params[1]
            if l_first is integer
                return objRemove(this, l_first, "")
            else
                return objRemove(this, l_first)
        } else if (a_params.maxIndex() > 1) {
            if (a_params[1] == a_params[1]*1 && a_params[2] == a_params[2]*1){ 
                l_min := round(a_params[1])
                l_max := round(a_params[2])
                l_range := []
                Loop, % (l_max - l_min) + 1
                {
                    l_range.insert( (l_min - 1 ) + A_Index )
                }
                For k, v in l_range {
                    objRemove(this, v, "")
                }
            } else {
                Return, objRemove(this, prm*)
            }
        } else {
            objRemove(this)
        }
    }

}

;; Override the Array() constructor for all arrays, even when called implicitly
;; a := [1, 2, 3, 4]  --->  Array([1, 2, 3, 4])
;; Lexikos <http://www.autohotkey.com/board/topic/83081-ahk-l-customizing-object-and-array/>
Array(a_params*){
    a_params.base := ObjectBase
    return a_params
}


;; Override the Object() constructor for all objects, even when called implicitly
;; a := {1: 2, 3: 4}  --->  Array([1, 2, 3, 4])
;; Lexikos <http://www.autohotkey.com/board/topic/83081-ahk-l-customizing-object-and-array/>
Object(a_params*){
    l_obj := new ObjectBase()
    Loop % a_params.MaxIndex() // 2
    {
        l_obj[a_params[A_Index*2-1]] := a_params[A_Index*2]
    }
    return l_obj
}



