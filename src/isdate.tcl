set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsDate not loaded because missing packages: $::GenMissingPackages."

     proc IsDate {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsDate StringValue {

     if {[catch {eval "clock scan {$StringValue} -format $GenNS::DateFormat"}]} {
          return 0
     } else {
          return 1
     }
}