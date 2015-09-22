set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Tomorrow not loaded because missing packages: $::GenMissingPackages."

     proc Tomorrow {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Tomorrow {} {

     return [eval "clock format [expr [clock seconds] + (3600*24)] -format $GenNS::DateFormat"]
}