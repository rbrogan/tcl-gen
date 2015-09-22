set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/q1.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "LastId not loaded because missing packages: $::GenMissingPackages."

     proc LastId {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc LastId TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     return [Q1 "SELECT id FROM $TableName ORDER BY id DESC LIMIT 1"]
}