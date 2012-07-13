class Math {

    xor(a,b){
        return ( !!a && !b ) || ( !!b && !a)
    }
    min(x,y){
        return x > y ? y : x
    }
    max(x,y){
        return x > y ? x : y
    }
    changeBase(n, b = 10){
        if (b > 16){
            throw "Cannot changeBase with base > 16"
        }
        s := ""
        while n {
            s := % SubStr("0123456789ABCDEF",  mod(n,b)+1, 1) s
            n := n \/\/ b
        }
        return s
    }
    hex(n){
        return % Math.changeBase(n,16)
    }
    oct(n){
        return % Math.changeBase(n,8)
    }
    fromHex(n){
        m := % "0x" n
        return % m + 0
    }
}
