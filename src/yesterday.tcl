set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Yesterday not loaded because missing packages: $::GenMissingPackages."

     proc Yesterday {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Yesterday {} {

     set SecondsPerDay [expr 60*60*24]
     return [eval "clock format [expr [clock seconds] - $SecondsPerDay] -format $GenNS::DateFormat"]
}