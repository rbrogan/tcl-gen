set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "BackupIfExists not loaded because missing packages: $::GenMissingPackages."

     proc BackupIfExists {VarName Value} "error \"$::GenPackageWarning\""

     return
}


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