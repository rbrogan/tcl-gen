set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/timeofdayisbefore.tcl

source $PackageRoot/timeofday2seconds.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "TimeOfDayIsAtOrAfter not loaded because missing packages: $::GenMissingPackages."

     proc TimeOfDayIsAtOrAfter {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc TimeOfDayIsAtOrAfter {FirstTimeOfDay SecondTimeOfDay} {

     return [expr ![TimeOfDayIsBefore $FirstTimeOfDay $SecondTimeOfDay]]
}