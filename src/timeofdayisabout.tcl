proc TimeOfDayIsAbout {TargetTimeOfDay IntervalMidpoint IntervalWidth {Option BothInclusive}} {

     if {[IsEmpty $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $IntervalMidpoint]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) IntervalMidpoint] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $IntervalWidth]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) IntervalWidth] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Option]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Option] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsTimeOfDay $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetTimeOfDay $TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {![IsTimeOfDay $IntervalMidpoint]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) IntervalMidpoint $IntervalMidpoint] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
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

     # Convert target time to seconds
     set CommandString "clock scan \"[Today] $TargetTimeOfDay\" -format $::GenNS::DatetimeFormat"
     set TargetTimeOfDayInSeconds [eval $CommandString]

     # Convert time interval to seconds
     set TotalScanned [scan $IntervalWidth "%dH %dM %dS" IntervalHours IntervalMinutes IntervalSeconds]
     if {$TotalScanned != 3} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) IntervalWidth $IntervalWidth] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set IntervalSeconds [expr ($IntervalHours * 60 * 60) + ($IntervalMinutes * 60) + $IntervalSeconds]

     # Convert interval midpoint to seconds
     set CommandString "clock scan \"[Today] $IntervalMidpoint\" -format $::GenNS::DatetimeFormat"
     set IntervalMidpointInSeconds [eval $CommandString]

     # Add and subtract to get interval endpoints
     set EarliestTime [expr $IntervalMidpointInSeconds - $IntervalSeconds]
     set LatestTime [expr $IntervalMidpointInSeconds + $IntervalSeconds]

     # See if target time is between earliest and latest times
     if {[expr ($EarliestTime $Sign1 $TargetTimeOfDayInSeconds) && ($TargetTimeOfDayInSeconds $Sign2 $LatestTime)]} {
          return 1
     } else {
          return 0
     }
}