set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FirstOf not loaded because missing packages: $::GenMissingPackages."

     proc FirstOf {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FirstOf ListValue {

     return [lindex $ListValue 0]
}