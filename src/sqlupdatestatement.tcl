proc SqlUpdateStatement {TableName SetDict {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $SetDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SetDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "UPDATE $TableName SET [SqlSetClause $SetDict]$WhereClause"
     return $sql
}