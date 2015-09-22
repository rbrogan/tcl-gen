set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DbgOff not loaded because missing packages: $::GenMissingPackages."

     proc DbgOff {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DbgOff ProcName {

     set GenNS::DebugOn 0
}