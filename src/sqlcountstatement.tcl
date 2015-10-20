proc SqlCountStatement {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set WhereClause [Coe " WHERE " [SqlWhereClause $DictValue]]
     return "SELECT count(1) FROM $TableName$WhereClause"
}