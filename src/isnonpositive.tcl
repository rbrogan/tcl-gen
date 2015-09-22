set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsNonPositive not loaded because missing packages: $::GenMissingPackages."

     proc IsNonPositive {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsNonPositive Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value <= 0} {
          return 1
     } else {
          return 0
     }
}