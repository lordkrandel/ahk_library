class Obj {

    ; Returns an object with keys and values swapped
    swap(arr){
        if (isobject(arr)){
            o := {}
            for k,v in arr {
                o.insert(v,k)
            }
            return o
        }
    }

    ; Returns the (first) position of an element in an array or object
    in( arr, val ){
        if (isobject(arr)){
            for k, v in arr {
                if ( v == val ){
                    return A_index
                }
            }
        }
    }

    ; Returns all the keys of an object
    keys(arr){
        if (isobject(arr)){
            o := {}
            for k, v in arr {
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
    isPureArray(obj, offset = 0){
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
            if ( %callback%(key, val, params*) )
               out[key] := val
            }
        }
        return out
    }

}
