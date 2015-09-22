set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DbgPrint not loaded because missing packages: $::GenMissingPackages."

     proc DbgPrint {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DbgPrint Message {

     if {$GenNS::DebugOn} {
          puts $Message
     }
}