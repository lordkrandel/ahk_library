class Obj {

    ; Returns an object with keys and values swapped
    swap(obj){
        if (isobject(obj)){
            o := {}
            for k,v in obj {
                o.insert(v,k)
            }
            return o
        }
    }

    ; Returns the (first) position of an element in an array or object
    in( obj, val ){
        if (isobject(obj)){
            for k, v in obj {
                if ( v == val ){
                    return A_index
                }
            }
        }
    }

    ; Returns all the keys of an object
    keys(obj){
        if (isobject(obj)){
            o := {}
            for k, v in obj {
                o.insert(k)
            }
            return o
        }
    }

    ; returns an (non-associative) array with the values in an object
    values(obj){
        if (isobject(obj)){
            o := {}
            for k, v in obj {
                o.insert(v)
            }
            return o
        }
    }

    ; checks if an object is a pure, continuous array
    isArray(obj, offset = 0){
        for key in obj {
            if ( key != (A_Index - offset ) ) {
                return 0
            }
        }
        return 1
    }

    ; passes all values to a callback and returns an array with the modified values
    map(obj, callback, params*) {
        out := {}
        for key, val in obj {
            out[key] := %callback%(val, params*)
        }
        return out
    }

    ; filters an object by the passed callback
    filter(obj, callback, params*) {
        out := {}
        for key, val in obj {
            if ( %callback%(key, val, params*) ){
               out[key] := val
            }
        }
        return out
    }

    ; put the element at the end of the array
    push( byref obj, el ){
        return obj.insert( el )
    }
    ; pop out the element at the end of the array
    pop( obj ){
        return obj.remove()
    }
    ; shift an element at the start of the array
    shift( byref obj, el ){
        n := [ el ]
        n.insert( obj* )
        obj := n
        return 1
    }
    ; unshift an element from the start of the array
    unshift( obj ){
        return obj.remove( obj.MinIndex() )
    }

}

