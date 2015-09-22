set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "LastOf not loaded because missing packages: $::GenMissingPackages."

     proc LastOf {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc LastOf ListValue {

     set Index [expr [llength $ListValue] - 1]
     return [lindex $ListValue $Index]
}