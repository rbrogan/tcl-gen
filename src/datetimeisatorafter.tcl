set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/datetimeisbefore.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DatetimeIsAtOrAfter not loaded because missing packages: $::GenMissingPackages."

     proc DatetimeIsAtOrAfter {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DatetimeIsAtOrAfter {FirstDatetime SecondDatetime} {

     return [expr ![DatetimeIsBefore $FirstDatetime $SecondDatetime]]
}