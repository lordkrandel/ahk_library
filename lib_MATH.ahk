;; Provides common arithmetic, logic and algebric functions for all string variables
class StringAsMathMixin {

    ;; Function Xor
    xor(a_arg) {
        return !!this && !a_arg || !!a_arg && !this
    }
 
    ;; Test current value between two values
    between(a_1, a_2) {
        return ( a_1 <= this && this <= a_2 )
    }

    ;; Change the base
    changeBase(a_base = 10) {
        if (a_base > 16){
            throw "Cannot changeBase with base > 16"
        }
        l_n := this
        while l_n {
            l_ret := % SubStr("0123456789ABCDEF", mod(l_n, a_base) + 1, 1) l_ret
            l_n := l_n // a_base
        }
        return "0x" l_ret
    }

    ;; Convert to hex
    hex() {
        return % this.changeBase(16)
    }

    ;; Convert to octal
    oct() {
        return % this.changeBase(8)
    }

    ;; Convert from hex
    fromHex() {
        l_ret := % "0x" this
        return % l_ret + 0
    }

    ;; 20141231 Returns 0 if it is 0 and 1 if other
    isNonZero(){
        return (this == 0 ? 0 : 1)
    }

    ;; 20141231 Returns 0 if it is 1 and 0 if other
    isZero(){
        return (this == 0 ? 1 : 0)
    }
}
