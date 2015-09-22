set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isdatetime.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DatetimeIsBetween not loaded because missing packages: $::GenMissingPackages."

     proc DatetimeIsBetween {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DatetimeIsBetween {FirstDatetime SecondDatetime ThirdDatetime {Option BothExclusive}} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }
     if {![IsDatetime $ThirdDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdDatetime $ThirdDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }

     switch -regexp $Option {
          BothExclusive {
               set Sign1 <
               set Sign2 <
          }
          BothInclusive {
               set Sign1 <=
               set Sign2 <=
          }
          (LeftExclusive|RightInclusive) {
               set Sign1 <
               set Sign2 <=
          }
          (LeftInclusive|RightExclusive) {
               set Sign1 <=
               set Sign2 <
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Option $Option] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
          }
     }

     set FirstSeconds [eval "clock scan {$FirstDatetime} -format $GenNS::DatetimeFormat"]
     set SecondSeconds [eval "clock scan {$SecondDatetime} -format $GenNS::DatetimeFormat"]
     set ThirdSeconds [eval "clock scan {$ThirdDatetime} -format $GenNS::DatetimeFormat"]
     if {$SecondSeconds > $ThirdSeconds} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondDatetime ThirdDatetime $SecondDatetime $ThirdDatetime]
     }

     set Expression "($SecondSeconds $Sign1 $FirstSeconds) && ($FirstSeconds $Sign2 $ThirdSeconds)"
     if {[expr $Expression]} {
          return 1
     } else {
          return 0
     }
}