set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsNonNegative not loaded because missing packages: $::GenMissingPackages."

     proc IsNonNegative {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsNonNegative Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value >= 0} {
          return 1
     } else {
          return 0
     }
}