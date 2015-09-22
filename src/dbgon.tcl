set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DbgOn not loaded because missing packages: $::GenMissingPackages."

     proc DbgOn {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DbgOn ProcName {

     set GenNS::DebugOn 1
}