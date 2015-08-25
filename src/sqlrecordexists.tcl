proc SqlRecordExists {TableName WhereDict} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $WhereDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set CountQuery [SqlCountStatement $TableName $WhereDict]
     set Count [Q1 $CountQuery]
     if {$Count > 0} {
          return 1
     } else {
          return 0
     }
}