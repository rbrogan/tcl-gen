proc RunSqlCreateTable {TableName ColumnNameTypeList} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $ColumnNameTypeList]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnNameTypeList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     # From the name-type list, make a string of the form:
     # name1 type1, name2 type2, ...
     set Flag 0
     set StringList ""
     foreach {Name Type} $ColumnNameTypeList {
          if {$Flag == 0} {
               set Flag 1
          } else {
               append StringList ", "
          }
          append StringList "$Name $Type"
     }
     # Construct a CREATE TABLE statement and execute it.
     set sql "CREATE TABLE $TableName ($StringList)"
     QQ $sql

     return
}