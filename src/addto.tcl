proc AddTo {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     set Var [expr $Var + $Value]
}