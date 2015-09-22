set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/coe.tcl

source $PackageRoot/sqlwhereclause.tcl

source $PackageRoot/sqlsetclause.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqlUpdateStatement not loaded because missing packages: $::GenMissingPackages."

     proc SqlUpdateStatement {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqlUpdateStatement {TableName SetDict {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $SetDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SetDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "UPDATE $TableName SET [SqlSetClause $SetDict]$WhereClause"
     return $sql
}