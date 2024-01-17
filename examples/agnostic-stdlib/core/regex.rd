
type RegEx {
    expression: String
    flags: String[]
}

type RegExResult = ??

RegEx(String, String) => RegEx
RegEx.test(RegEx, String) => Boolean
RegEx.run(RegEx, String) => RegExResult