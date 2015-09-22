set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isdate.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DateIsAfter not loaded because missing packages: $::GenMissingPackages."

     proc DateIsAfter {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DateIsAfter {FirstDate SecondDate} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set FirstSeconds [eval "clock scan {$FirstDate} -format $GenNS::DateFormat"]
     set SecondSeconds [eval "clock scan {$SecondDate} -format $GenNS::DateFormat"]
     if {$SecondSeconds < $FirstSeconds} {
          return 1
     } else {
          return 0
     }
}