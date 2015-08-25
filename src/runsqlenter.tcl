proc RunSqlEnter {TableName WhereDict {SetDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $WhereDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # If we have just a WhereDict then this reduces to an insert if does not exist.
     if {[IsEmpty $SetDict]} {
          return [RunSqlInsertIfDoesNotExist $TableName $WhereDict]
     }
     # Otherwise we have to do the equivalent except that even when it does exist,
     # we still do an update using the SetDict.
     # Construct SELECT and determine if an entry exists
     set sql "SELECT id FROM $TableName WHERE [SqlWhereClause $WhereDict]"
     set Id [Q1 $sql]
     if {[NotEmpty $Id]} {
          # If so, construct an update
          set sql [SqlUpdateStatement $TableName $SetDict $WhereDict]
          QQ $sql
     } else {
          # If not, construct an insert
          set sql [SqlInsertStatement $TableName [dict merge $WhereDict $SetDict]]
          QQ $sql
          set Id [LastId $TableName]
     }
     
     return $Id
}