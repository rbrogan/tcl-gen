proc DeleteEverythingInDirectory TargetDirectoryPath {

     if {[IsEmpty $TargetDirectoryPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TargetDirectoryPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     foreach File [glob -nocomplain -directory $TargetDirectoryPath *] {
          file delete -force $File
     }
}