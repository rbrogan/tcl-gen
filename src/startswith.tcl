set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "StartsWith not loaded because missing packages: $::GenMissingPackages."

     proc StartsWith {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc StartsWith {TargetString SearchValue} {

     if {[string first $SearchValue $TargetString] == 0} {
          return 1
     } else {
          return 0
     }
}