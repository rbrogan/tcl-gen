set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "StringContains not loaded because missing packages: $::GenMissingPackages."

     proc StringContains {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc StringContains {TargetString SearchValue} {

     if {[string first $SearchValue $TargetString] != -1} {
          return 1
     } else {
          return 0
     }
}