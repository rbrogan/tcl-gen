set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "RetZeroIfEmpty not loaded because missing packages: $::GenMissingPackages."

     proc RetZeroIfEmpty {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc RetZeroIfEmpty Value {

     if {[IsEmpty $Value]} {
          return 0
     } else {
          return $Value
     }
}