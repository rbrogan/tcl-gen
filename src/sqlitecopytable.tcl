set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/sqlitetableexists.tcl

source $PackageRoot/sqlitecolumnnameandtypelist.tcl

source $PackageRoot/runsqlcreatetable.tcl

source $PackageRoot/qq.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqliteCopyTable not loaded because missing packages: $::GenMissingPackages."

     proc SqliteCopyTable {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqliteCopyTable {SourceTableName TargetTableName {ColumnNames ""}} {

     if {[IsEmpty $SourceTableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SourceTableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $TargetTableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TargetTableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Make sure target table does not already exist
     if {[SqliteTableExists $TargetTableName]} {
          error [format "$::ErrorMessage(INPUT_INVALID) Target table already exists." $TargetTableName] $::errorInfo $::ErrorCode(INPUT_INVALID)
     }
     set NameAndTypeList [SqliteColumnNameAndTypeList $SourceTableName]
     # Verify NameAndTypeList and ColumnNames have congruent length.
     if {([llength $ColumnNames] > 0) && ([llength $ColumnNames] * 2) != ([llength $NameAndTypeList])} {
          error [format "$::ErrorMessage(VARIABLE_CONTENTS_INVALID) Number of elements does not match number of columns in table." ColumnNames $ColumnNames] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }
     for {set i 0} {$i < [llength $ColumnNames]} {incr i} {
          lset NameAndTypeList [expr $i * 2] [lindex $ColumnNames $i]
     }
     RunSqlCreateTable $TargetTableName $NameAndTypeList
     # Copy from source to target
     set sql "INSERT INTO $TargetTableName SELECT * FROM $SourceTableName"
     QQ $sql
}