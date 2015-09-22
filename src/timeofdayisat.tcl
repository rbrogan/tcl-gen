set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/istimeofday.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "TimeOfDayIsAt not loaded because missing packages: $::GenMissingPackages."

     proc TimeOfDayIsAt {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc TimeOfDayIsAt {FirstTimeOfDay SecondTimeOfDay} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [string equal $FirstTimeOfDay $SecondTimeOfDay]
}