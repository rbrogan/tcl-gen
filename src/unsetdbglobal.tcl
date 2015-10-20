proc UnsetDbGlobal VarName {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set ::sql "DELETE FROM $GenNS::GlobalsTable WHERE desc = '$VarName'"
     QQ $::sql
}