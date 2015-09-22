set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isdatetime.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DatetimeIsAt not loaded because missing packages: $::GenMissingPackages."

     proc DatetimeIsAt {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DatetimeIsAt {FirstDatetime SecondDatetime} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [string equal $FirstDatetime $SecondDatetime]
}