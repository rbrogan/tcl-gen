proc LinkVarToDbGlobal {VarName {DbGlobalName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DbGlobalName]} {
          set DbGlobalName $VarName
     }
     UpvarX $VarName Var
     uplevel "SetDbGlobal $DbGlobalName {$Var}"
     uplevel "trace add variable $VarName write \"UpdateDbGlobal $VarName $DbGlobalName\""
}