proc SqlSelectStatement {TableName {TargetList *} {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $TargetList]} {
          set TargetList *
     }
     set TargetClause [join $TargetList ", "]
     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "SELECT $TargetClause FROM $TableName$WhereClause"
     return $sql
}