set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "QuoteIfColumnTypeIsText not loaded because missing packages: $::GenMissingPackages."

     proc QuoteIfColumnTypeIsText {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc QuoteIfColumnTypeIsText {TableName ColumnName TargetVariable} {
     if {[string first @ $TargetVariable] == 0} {
          UpvarExistingOrDie [string range $TargetVariable 1 end] Target
     } else {
          set Target $TargetVariable
     }

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $ColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Target]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Target] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     # Find the type of the target column.
     # If it is text then escape and single quote the string, and return that.
     # Otherwise, return back the same input, unchanged.
     set ColumnType [SqliteColumnType $TableName $ColumnName]
     if {$ColumnType eq "text"} {
          set Target "'[EscapedSqlString $Target]'"
     }

     return $Target
}