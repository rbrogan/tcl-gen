set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/q1.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqliteColumnNameList not loaded because missing packages: $::GenMissingPackages."

     proc SqliteColumnNameList {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqliteColumnNameList TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Get the CREATE TABLE statement used (or throw error if cannot find)
     set sql "SELECT sql FROM sqlite_master WHERE tbl_name = '$TableName'"
     set Result [Q1 $sql]
     if {[IsEmpty $Result]} {
          error [format $::ErrorMessage(TABLE_NOT_FOUND) $TableName] $::errorInfo $::ErrorCode(TABLE_NOT_FOUND)    
     }
     # Extract from the statement a list of name-type values for columns.
     regexp {CREATE TABLE \w+ \((.+)\)} $Result All One
     set Two [split $One ","]
     # Construct a list with just the column names.
     set Three {}
     foreach Element $Two { 
          lappend Three [lindex $Element 0] 
     }
     return $Three
}