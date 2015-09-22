set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsTimeOfDay not loaded because missing packages: $::GenMissingPackages."

     proc IsTimeOfDay {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsTimeOfDay StringValue {

     if {[catch {eval "clock scan {$StringValue} -format $GenNS::TimeOfDayFormat"}]} {
          return 0
     } else {
          return 1
     }
}