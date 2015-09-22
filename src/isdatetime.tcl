set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsDatetime not loaded because missing packages: $::GenMissingPackages."

     proc IsDatetime {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsDatetime StringValue {

     set CommandString "clock scan {$StringValue} -format $GenNS::DatetimeFormat"
     if {[catch $CommandString Temp]} {
          return 0
     } else {
          return 1
     }
}