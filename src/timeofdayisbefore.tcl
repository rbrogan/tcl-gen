set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/istimeofday.tcl

source $PackageRoot/timeofday2seconds.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "TimeOfDayIsBefore not loaded because missing packages: $::GenMissingPackages."

     proc TimeOfDayIsBefore {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc TimeOfDayIsBefore {FirstTimeOfDay SecondTimeOfDay} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstSeconds [TimeOfDay2Seconds $FirstTimeOfDay]
     set SecondSeconds [TimeOfDay2Seconds $SecondTimeOfDay]
     if {$FirstSeconds < $SecondSeconds} {
          return 1
     } else {
          return 0
     }
}