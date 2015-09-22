set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/sqlitecolumnnameandtypelist.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqliteColumnType not loaded because missing packages: $::GenMissingPackages."

     proc SqliteColumnType {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqliteColumnType {TableName ColumnName} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $ColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set List [SqliteColumnNameAndTypeList $TableName]
     return [dict get $List $ColumnName]
}