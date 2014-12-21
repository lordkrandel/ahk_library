;; Test class for String
class StringTest{
    
    ;; check the fmt format result 
    fmt_test(a_format, a_expected, a_params*){
        l_actual := a_format.fmt(a_params*)
        if (l_actual != a_expected)
            throw "fmt_test() format: " a_format " , expected: " a_expected ", actual: " l_actual
        return (l_actual != a_expected)
    }
    
    ;; run the tests
    run(){

        l := 6.777
        StringTest.fmt_test("%09.5.f", "000677700", l)
        StringTest.fmt_test("%09.5f",  "006.77700", l)
        StringTest.fmt_test("%s",      "6.777"    , l)
        StringTest.fmt_test("%8s",     "6.777   " , l)
        StringTest.fmt_test("%-8s",    "   6.777" , l)
        StringTest.fmt_test("%%",      "%"        , l)

        if !("1".is("number") == 1)
            throw Exception("""1"".is(""number"" == 1")
 
        if !("3".in("a4a3") == 4)
            throw Exception("""3"".in(""a4a3"" == 4")

        if !("3".in(["a", "4", "a", "3"]) == 4)
            throw Exception("""3"".in([""a"", ""4"", ""a"", ""3"" == 4")

        if !("3".qq() == """3""")
            throw Exception("""3"".qq( == """"""3"""""" ")

        if !("sunday".distance("saturday") == 3)
            throw Exception("""sunday"".distance(""saturday"" == 3")

    }
}