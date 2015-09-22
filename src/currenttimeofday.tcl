set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "CurrentTimeOfDay not loaded because missing packages: $::GenMissingPackages."

     proc CurrentTimeOfDay {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc CurrentTimeOfDay {} {

     return [eval "clock format [clock seconds] -format $GenNS::TimeOfDayFormat"]
}