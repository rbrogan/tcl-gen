proc GetDbGlobal {VarName {Type text}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     # Determine name of column to query based on the type specified.
     switch $Type {
          text {
               set ValueType textvalue
          }
          (int|integer) {
               set ValueType intvalue
          }
          (real|float|double) {
               set ValueType realvalue
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Type $Type] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }
     # We have to verify that the record exists with an additional query,
     # in order to differentiate instance where variable exists but has null string
     # versus instance where it does not exist.
     if {[SqlRecordExists $GenNS::GlobalsTable "desc '$VarName'"]} {
          set sql "SELECT textvalue FROM $GenNS::GlobalsTable WHERE desc = \"$VarName\""               
          return [Q1 $sql]
     } else {
          error [format $::ErrorMessage(DATABASE_VARIABLE_NOT_FOUND) $VarName] $::errorInfo $::ErrorCode(DATABASE_VARIABLE_NOT_FOUND)
     }

}