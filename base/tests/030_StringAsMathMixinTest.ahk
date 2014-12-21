;; StringAsMathMixin test class
class StringAsMathMixinTest extends TestBase {

    ;; Runs all tests
    run(){ 
    
        if !( 0.xor(1) ){
            throw Exception("0.xor(1) == 1 failed")
        }
        if !( (255).hex() == "0xFF"){
            throw Exception("(255).hex() == ""0xFF"" failed")
        }
        if !( (255).oct() == "0x377"){
            throw Exception("(255).oct() == ""0x377"" failed")
        }
        if !( "FF".fromHex() == 255){
            throw Exception("(""FF"").fromHex() == 255 failed")
        }
        if !( (3).between(1,5)){
            throw Exception("(3).between(1,5) failed")
        }
        if !( (7).between(1,5) == 0){
            throw Exception("(7).between(1,5) == 0 failed")
        }

    }

}