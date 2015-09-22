set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DeleteEverythingInDirectory not loaded because missing packages: $::GenMissingPackages."

     proc DeleteEverythingInDirectory {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DeleteEverythingInDirectory TargetDirectoryPath {

     if {[IsEmpty $TargetDirectoryPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TargetDirectoryPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     foreach File [glob -nocomplain -directory $TargetDirectoryPath *] {
          file delete -force $File
     }
}