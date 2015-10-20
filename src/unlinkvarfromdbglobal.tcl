proc UnlinkVarFromDbGlobal {VarName {DbGlobalName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DbGlobalName]} {
          set DbGlobalName $VarName
     }
     uplevel "trace remove variable $VarName write \{UpdateDbGlobal $VarName $DbGlobalName\}"
}