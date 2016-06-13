proc ShowTable {TableName {ColumnNames ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $ColumnNames]} {
          set ColumnNames [SqliteColumnNameList $TableName]
     }

     set NumColumns [llength $ColumnNames]
     set sql "SELECT [join $ColumnNames ,] FROM $TableName"
     set Results [QQ $sql]
     if {[NotEmpty $Results]} {
          set Results [Raise $Results $NumColumns]
     }
     PrintMatrix $Results $ColumnNames
}