proc SetZeroIfEmpty VarName {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     UpvarX $VarName Var
     if {[IsEmpty $Var]} {
          set Var 0
     }
     
     return $Var
}