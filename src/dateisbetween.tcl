set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isdate.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DateIsBetween not loaded because missing packages: $::GenMissingPackages."

     proc DateIsBetween {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DateIsBetween {FirstDate SecondDate ThirdDate {Option BothExclusive}} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $ThirdDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdDate $ThirdDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
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

     set FirstSeconds [eval "clock scan {$FirstDate} -format $GenNS::DateFormat"]
     set SecondSeconds [eval "clock scan {$SecondDate} -format $GenNS::DateFormat"]
     set ThirdSeconds [eval "clock scan {$ThirdDate} -format $GenNS::DateFormat"]

     if {$SecondSeconds > $ThirdSeconds} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondDate ThirdDate $SecondDate $ThirdDate] $::errorInfo $::ErrorCode(ARGUMENTS_INCOHERENT)
     }

     set Expression "($SecondSeconds $Sign1 $FirstSeconds) && ($FirstSeconds $Sign2 $ThirdSeconds)"
     if {[expr $Expression]} {
          return 1
     } else {
          return 0
     }
}