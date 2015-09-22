set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/dateisbefore.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DateIsOnOrAfter not loaded because missing packages: $::GenMissingPackages."

     proc DateIsOnOrAfter {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DateIsOnOrAfter {FirstDate SecondDate} {

     return [expr ![DateIsBefore $FirstDate $SecondDate]]
}