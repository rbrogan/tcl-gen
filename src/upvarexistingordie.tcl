proc UpvarExistingOrDie {VarName Var} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {[IsEmpty $Var]} {
          error "Second argument is missing. Got empty string." $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }     
     if {[VarExistsInCaller $VarName 2]} {
          uplevel "upvar $VarName $Var"
     } else {
          error [format $::ErrorMessage(VARIABLE_NOT_FOUND) $VarName] $::errorInfo $::ErrorCode(VARIABLE_NOT_FOUND)
     }
     
     return
}