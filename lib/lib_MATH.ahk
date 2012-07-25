; Provides common arithmetic, logic and algebric functions.
class Math {


    ; Function Xor
    xor(a, b) {
        return !!a && !b || !!b && !a
    }
    min(x,y = "") {
        if y is not number
        {
            if (y == ""){
                return Math.minObj(x)
            }
        }
        return x > y ? y : x
    }
    max(x,y = "") {
        if y is not number
        {
            if (y == ""){
                return Math.maxObj(x)
            }
        }
        return x > y ? x : y
    }
    minObj(x) {
        if (!isObject(x)){
            return
        }
        c := 0
        d := 0
        for k, v in x {
            if ( !d ){
                c := v
                d := 1
            } else {
                c := Math.min( c, v )
            }
        }
        return c
    }
    maxObj(x) {
        if (!isObject(x)){
            return
        }
        c := 0
        d := 0
        for k, v in x {
            if ( !d ) {
                c := v
                d := 1
            } else {
                c := Math.max( c, v )
            }
        }
        return c
    }
    between(x,y,z) {
        return ( x <= y && y <= z )
    }

    changeBase(n, b = 10) {
        if (b > 16){
            throw "Cannot changeBase with base > 16"
        }
        s := ""
        while n {
            s := % SubStr("0123456789ABCDEF",  mod(n,b)+1, 1) s
            n := n // b
        }
        return s
    }
    hex(n) {
        return % Math.changeBase(n,16)
    }
    oct(n) {
        return % Math.changeBase(n,8)
    }
    fromHex(n) {
        m := % "0x" n
        return % m + 0
    }
}
