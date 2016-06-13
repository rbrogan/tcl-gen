proc PrintVars VarNameList {

     foreach VarName $VarNameList {
          if {[IsEmpty $VarName]} {
               error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo      $::ErrorCode(VARIABLE_NAME_EMPTY)
          }
          UpvarExistingOrDie $VarName Var
     }
  
     foreach VarName $VarNameList {
          puts "$VarName is $Var"
     }
     
     return
}