set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/dateisafter.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DateIsOnOrBefore not loaded because missing packages: $::GenMissingPackages."

     proc DateIsOnOrBefore {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DateIsOnOrBefore {FirstDate SecondDate} {

     return [expr ![DateIsAfter $FirstDate $SecondDate]]
}