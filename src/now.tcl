set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Now not loaded because missing packages: $::GenMissingPackages."

     proc Now {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Now {} {

     return [eval "clock format [clock seconds] -format $GenNS::DatetimeFormat"]
}