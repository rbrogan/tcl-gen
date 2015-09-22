set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/coe.tcl

source $PackageRoot/sqlwhereclause.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqlSelectStatement not loaded because missing packages: $::GenMissingPackages."

     proc SqlSelectStatement {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqlSelectStatement {TableName {TargetList *} {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $TargetList]} {
          set TargetList *
     }
     set TargetClause [join $TargetList ", "]
     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "SELECT $TargetClause FROM $TableName$WhereClause"
     return $sql
}