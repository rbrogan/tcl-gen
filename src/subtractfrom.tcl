set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarx.tcl

source $PackageRoot/setzeroifempty.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SubtractFrom not loaded because missing packages: $::GenMissingPackages."

     proc SubtractFrom {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SubtractFrom {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     set Var [expr $Var - $Value]
}