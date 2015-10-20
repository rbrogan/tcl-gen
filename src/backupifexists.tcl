proc BackupIfExists {FilePathValue {Extension "bak"}} {

     if {[IsEmpty $FilePathValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FilePathValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Extension]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Extension] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[file exists $FilePathValue]} {
          set BackupPath "[set FilePathValue].[set Extension]"
          file copy -force $FilePathValue $BackupPath
          return 1
     } else {
          return 0
     }
}