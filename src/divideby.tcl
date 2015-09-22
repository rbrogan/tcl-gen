set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DivideBy not loaded because missing packages: $::GenMissingPackages."

     proc DivideBy {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DivideBy {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarExistingOrDie $VarName Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     set Var [expr $Var / $Value]
     return $Var
}