set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/coe.tcl

source $PackageRoot/sqlwhereclause.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqlCountStatement not loaded because missing packages: $::GenMissingPackages."

     proc SqlCountStatement {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqlCountStatement {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set WhereClause [Coe " WHERE " [SqlWhereClause $DictValue]]
     return "SELECT count(1) FROM $TableName$WhereClause"
}