proc VarExistsInCaller {VarName {LevelOffset 1}} {

     set Level [expr $LevelOffset + 1]
     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     set command "info exists $VarName"
     return [uplevel $Level $command]
}