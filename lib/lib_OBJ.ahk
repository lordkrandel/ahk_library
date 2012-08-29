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

	; returns an (non-associative) array with the values in an object
	values(obj)
	{
		if (isobject(obj)){
			o := {}
			for k, v in obj {
				o.insert(v)
			}
			return o
        }
	}

	; checks if an object is a pure, continous array
	isPureArray(obj, zeroBased = false)
	{
		for key in obj {
			if (key != (A_Index - (zeroBased ? 1 : 0))) {
				return false
			}
		}
		return true
	}

	; passes all values to a callback and returns an array with the modified values
	map(obj, callback, param = "")
	{
		out := {}
		for key, val in obj {
			if (param)
				out[key] := %callback%(val, param)
			else
				out[key] := %callback%(val)
		}
		return out
	}

	; filters an object by the passed callback
	filter(obj, callback, param = "")
	{
		out := {}
		for key, val in obj {
			if (param) {
				if (%callback%(key, val, param))
					out[key] := val
			} else {
				if (%callback%(key, val))
					out[key] := val
			}
		}
		return out
	}
}