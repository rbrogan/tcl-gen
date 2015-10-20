proc RestoreIfExists {FilePathValue {Extension "bak"}} {

     if {[IsEmpty $FilePathValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FilePathValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Extension]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Extension] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set BackupPath "[set FilePathValue].[set Extension]"
     if {[file exists $BackupPath]} {
          file copy -force $BackupPath $FilePathValue
          return 1
     } else {
          return 0
     }
}