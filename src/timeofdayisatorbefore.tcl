set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/timeofdayisafter.tcl

source $PackageRoot/timeofday2seconds.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "TimeOfDayIsAtOrBefore not loaded because missing packages: $::GenMissingPackages."

     proc TimeOfDayIsAtOrBefore {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc TimeOfDayIsAtOrBefore {FirstTimeOfDay SecondTimeOfDay} {

     return [expr ![TimeOfDayIsAfter $FirstTimeOfDay $SecondTimeOfDay]]
}