set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isdatetime.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DatetimeIsAfter not loaded because missing packages: $::GenMissingPackages."

     proc DatetimeIsAfter {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DatetimeIsAfter {FirstDatetime SecondDatetime} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set FirstSeconds [eval "clock scan {$FirstDatetime} -format $GenNS::DatetimeFormat"]
     set SecondSeconds [eval "clock scan {$SecondDatetime} -format $GenNS::DatetimeFormat"]
     if {$FirstSeconds > $SecondSeconds} {
          return 1
     } else {
          return 0
     }
}