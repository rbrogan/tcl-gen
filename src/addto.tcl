set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarx.tcl

source $PackageRoot/setzeroifempty.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "AddTo not loaded because missing packages: $::GenMissingPackages."

     proc AddTo {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc AddTo {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     set Var [expr $Var + $Value]
}