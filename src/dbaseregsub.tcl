set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/coe.tcl

source $PackageRoot/sqlwhereclause.tcl

source $PackageRoot/qq.tcl

source $PackageRoot/escapedsqlstring.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DbaseRegsub not loaded because missing packages: $::GenMissingPackages."

     proc DbaseRegsub {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DbaseRegsub {TableName ColumnName FindValue ReplaceValue {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $ColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $FindValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FindValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "SELECT id, $ColumnName FROM $TableName[set WhereClause]"
     set TotalReplacements 0
     set Results [QQ $sql]
     foreach {Id OldValue} $Results {
          set NumReplacements [regsub -all $FindValue $OldValue $ReplaceValue NewValue]
          if {$NumReplacements > 0} {
               set sql "UPDATE $TableName SET $ColumnName = '[EscapedSqlString $NewValue]' WHERE id = $Id"
               QQ $sql
               incr TotalReplacements
          }
     }
     return $TotalReplacements
}