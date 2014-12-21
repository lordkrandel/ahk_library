;; Object base class test class
class ObjectTest extends TestBase {
    testProperty := "testProperty"
    filtertest(k, v){
        return (k < 3)
    }    
    maptest(k, v){
        return v - 1
    }    
    run(){       

        l_ret := [1,2,3,5].values().filter("ObjectTest.filtertest").join("|")
        if !(l_ret == "1|2"){
            throw Exception(""
                . "[1,2,3,5].values().filter(""ObjectTest.filtertest"").join(""|"") == ""1|2""")
        }
        l_ret := [1,2,3,4].map("ObjectTest.maptest").join("|")
        if !(l_ret == "0|1|2|3"){
            throw Exception(""
                . "[1,2,3,4].map(""ObjectTest.maptest"").join(""|"") == ""0|1|2|3""")
        }
        l_ret := [3,4,2,1].min()
        if !(l_ret == 1){
            throw Exception("[3,4,2,1].min() == 1")
        }
        l_ret := [3,4,2,1].max()
        if !(l_ret == 4){
            throw Exception("[3,4,2,1].max() == 4")
        }
        ; 20142012 new map() features
        ; "|".join([ y.between(1,3) for y in x])
        l_ret := [3,4,2,1].map("this.between", 1, 3).join("|")
        if !(l_ret == "1|0|1|1"){
            throw Exception("[3,4,2,1].map(""this.between"", 1, 3).join("|") == ""1|0|1|1""")
        }
        ; "|".join([y[1] for y in x])
        l_ret := [[0,1],[0,1],[1,0],[0,1]]
        l_ret := l_ret.map("this.__get", 1).join("|")
        if !(l_ret == "0|0|1|0"){
            throw Exception("[[0,1],[0,1],[1,0],[0,1]].map(""this.__get"", 1).join(""|"") == ""0|0|1|0"" ")
        }
        
        if !(this.testProperty == "testProperty"){
            throw Exception("testProperty could not be read")
        }
    }
}