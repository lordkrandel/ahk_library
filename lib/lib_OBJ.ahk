class OBJ {

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
}