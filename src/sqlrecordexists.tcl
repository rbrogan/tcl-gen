set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/sqlcountstatement.tcl

source $PackageRoot/q1.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqlRecordExists not loaded because missing packages: $::GenMissingPackages."

     proc SqlRecordExists {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqlRecordExists {TableName WhereDict} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $WhereDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set CountQuery [SqlCountStatement $TableName $WhereDict]
     set Count [Q1 $CountQuery]
     if {$Count > 0} {
          return 1
     } else {
          return 0
     }
}