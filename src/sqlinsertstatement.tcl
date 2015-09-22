set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqlInsertStatement not loaded because missing packages: $::GenMissingPackages."

     proc SqlInsertStatement {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqlInsertStatement {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set KeyList {}
     set ValueList {}
     dict for {Key Value} $DictValue {
          lappend KeyList $Key
          lappend ValueList $Value
     }
     set sql "INSERT INTO $TableName ([join $KeyList ", "]) VALUES ([join $ValueList ", "])"
     return $sql
}