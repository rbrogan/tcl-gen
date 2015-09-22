set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/datetimeisafter.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DatetimeIsAtOrBefore not loaded because missing packages: $::GenMissingPackages."

     proc DatetimeIsAtOrBefore {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DatetimeIsAtOrBefore {FirstDatetime SecondDatetime} {

     return [expr ![DatetimeIsAfter $FirstDatetime $SecondDatetime]]
}