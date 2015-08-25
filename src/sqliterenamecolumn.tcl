proc SqliteRenameColumn {TableName OldColumnName NewColumnName} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $OldColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) OldColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $NewColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) NewColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set NameAndTypeList [SqliteColumnNameAndTypeList $TableName]
     set Index [lsearch $NameAndTypeList $NewColumnName]
     if {$Index >= 0} {
          error [format "$::ErrorMessage(VARIABLE_CONTENTS_INVALID) A column with that name already exists." NewColumnName $NewColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }
     set Index [lsearch $NameAndTypeList $OldColumnName]
     if {$Index < 0} {
          error [format "$::ErrorMessage(VARIABLE_CONTENTS_INVALID) No such column found." OldColumnName $OldColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     lset NameAndTypeList $Index $NewColumnName
     if {[SqliteTableExists gen_temp_rename_column_table]} {
          set sql "DROP TABLE gen_temp_rename_column_table"
          QQ $sql
     }
     RunSqlCreateTable gen_temp_rename_column_table $NameAndTypeList
     # Copy from source to target
     set sql "INSERT INTO gen_temp_rename_column_table SELECT * FROM $TableName"
     QQ $sql
     set sql "DROP TABLE $TableName"
     QQ $sql
     set sql "ALTER TABLE gen_temp_rename_column_table RENAME TO $TableName"
     QQ $sql
}