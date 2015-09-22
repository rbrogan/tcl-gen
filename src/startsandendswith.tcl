set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/endswith.tcl

source $PackageRoot/startswith.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "StartsAndEndsWith not loaded because missing packages: $::GenMissingPackages."

     proc StartsAndEndsWith {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc StartsAndEndsWith {TargetString SearchValue} {

     if {[StartsWith $TargetString $SearchValue] && [EndsWith $TargetString $SearchValue]} {
          return 1
     } else {
          return 0
     }
}