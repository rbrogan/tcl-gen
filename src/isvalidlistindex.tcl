set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isnegative.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsValidListIndex not loaded because missing packages: $::GenMissingPackages."

     proc IsValidListIndex {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsValidListIndex {ListValue Index} {

     if {![string is integer $Index]} {
          return 0
     } elseif {[IsNegative $Index]} {
          return 0
     } elseif {[llength $ListValue] <= $Index} {
          return 0
     } else {
          return 1
     }
}