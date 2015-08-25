proc LastId TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     return [Q1 "SELECT id FROM $TableName ORDER BY id DESC LIMIT 1"]
}