set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "ListEndIndex not loaded because missing packages: $::GenMissingPackages."

     proc ListEndIndex {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc ListEndIndex ListValue {

     return [expr [llength $ListValue] - 1]
}