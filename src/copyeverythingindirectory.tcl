proc CopyEverythingInDirectory {SourceDirectoryPath DestinationDirectoryPath} {

     if {[IsEmpty $SourceDirectoryPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SourceDirectoryPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $DestinationDirectoryPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DestinationDirectoryPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {$SourceDirectoryPath eq $DestinationDirectoryPath} {
          error "Source and destination directory are both $SourceDirectoryPath."
     }

     if {![file exists $DestinationDirectoryPath] || ![file isdirectory $DestinationDirectoryPath]} {
          file mkdir $DestinationDirectoryPath          
     }

     foreach File [glob -nocomplain -directory $SourceDirectoryPath *] {
          if {[file isdirectory $File]} {
               CopyEverythingInDirectory $File $DestinationDirectoryPath/[file tail $File]
          } else {
               file copy -force $File $DestinationDirectoryPath
          }
     }
}