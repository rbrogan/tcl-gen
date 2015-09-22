set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/q1.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqliteTableExists not loaded because missing packages: $::GenMissingPackages."

     proc SqliteTableExists {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqliteTableExists TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set sql "SELECT count(*) FROM sqlite_master WHERE tbl_name = '$TableName'"
     return [Q1 $sql]
}