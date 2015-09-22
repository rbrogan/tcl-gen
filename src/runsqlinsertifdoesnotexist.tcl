set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/sqlselectstatement.tcl

source $PackageRoot/q1.tcl

source $PackageRoot/qq.tcl

source $PackageRoot/lastid.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "RunSqlInsertIfDoesNotExist not loaded because missing packages: $::GenMissingPackages."

     proc RunSqlInsertIfDoesNotExist {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc RunSqlInsertIfDoesNotExist {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Get the ID of the record if it does exist.
     set sql [SqlSelectStatement $TableName id $DictValue]
     set Id [Q1 $sql]
     if {[IsEmpty $Id]} {
          # If no record was found then do an insert and get the ID.
          set sql "INSERT INTO $TableName ([join [dict keys $DictValue] ","]) VALUES ([join [dict values $DictValue] ","])"
          QQ $sql
          set Id [LastId $TableName]
     }
     return $Id
}