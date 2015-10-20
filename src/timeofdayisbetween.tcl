proc TimeOfDayIsBetween {FirstTimeOfDay SecondTimeOfDay ThirdTimeOfDay {Option BothExclusive}} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $ThirdTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdTimeOfDay $ThirdTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
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
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Option $Option] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }


     set FirstSeconds [TimeOfDay2Seconds $FirstTimeOfDay]
     set SecondSeconds [TimeOfDay2Seconds $SecondTimeOfDay]
     set ThirdSeconds [TimeOfDay2Seconds $ThirdTimeOfDay]

     if {[expr $SecondSeconds > $ThirdSeconds]} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondTimeOfDay ThirdTimeOfDay $SecondTimeOfDay $ThirdTimeOfDay] $::errorInfo $::ErrorCode(ARGUMENTS_INCOHERENT)
     }

     if {[expr ($SecondSeconds $Sign1 $FirstSeconds) && ($FirstSeconds $Sign2 $ThirdSeconds)]} {
          return 1
     } else {
          return 0
     }
}