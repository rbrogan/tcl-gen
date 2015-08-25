proc SqliteTableExists TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set sql "SELECT count(*) FROM sqlite_master WHERE tbl_name = '$TableName'"
     return [Q1 $sql]
}