set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Today not loaded because missing packages: $::GenMissingPackages."

     proc Today {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Today {} {

     return [eval "clock format [clock seconds] -format $GenNS::DateFormat"]
}