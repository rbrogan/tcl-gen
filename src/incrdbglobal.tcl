set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/sqlrecordexists.tcl

source $PackageRoot/q1.tcl

source $PackageRoot/isnonnumeric.tcl

source $PackageRoot/setdbglobal.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IncrDbGlobal not loaded because missing packages: $::GenMissingPackages."

     proc IncrDbGlobal {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IncrDbGlobal {VarName {Amount 1}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Try to get the value of the variable,
     # and if it does not already exist, make it zero.
     # Try to get the value, and if it does not exist then make it zero.
     if {[SqlRecordExists $GenNS::GlobalsTable "desc '$VarName'"]} {
          set sql "SELECT textvalue FROM $GenNS::GlobalsTable WHERE desc = \"$VarName\""               
          set CurrentValue [Q1 $sql]
     } else {
          set CurrentValue 0
     }

     if {[IsNonNumeric $CurrentValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $CurrentValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Amount]} {
          error [format "Amount is invalid. $::ErrorMessage(INPUT_NON_NUMERIC)" $Amount] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }

     # Increment the value by one.
     set NewValue [expr $CurrentValue + $Amount]

     # The value back to the database.
     SetDbGlobal $VarName $NewValue

     # Return the now-current value.
     return $NewValue
}