proc UpvarX {VarName Var {DefaultValue ""}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {[IsEmpty $Var]} {
          error "Second argument is missing. Got empty string." $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }     
     if {[VarExistsInCaller $VarName 2]} {
          uplevel 1 "upvar $VarName $Var"
     } else {
          uplevel 1 "upvar $VarName $Var"
          if {[NotEmpty $DefaultValue]} {
               uplevel 1 "set $Var $DefaultValue"
          } else {
               uplevel 1 "set $Var {}"
          }
     }
     
     return
}