proc Prepend {StringVarName Value} {

     UpvarX $StringVarName String
     set String "[set Value][set String]"
     return $String
}