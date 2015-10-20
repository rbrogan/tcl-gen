proc Decr {VarName {IntegerValue ""}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {![string is integer $IntegerValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) IntegerValue $IntegerValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Var]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $Var] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Var [expr $Var - [Ter {[NotEmpty $IntegerValue]} {return $IntegerValue} {return 1}]]
}