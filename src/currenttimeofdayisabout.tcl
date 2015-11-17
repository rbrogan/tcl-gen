proc CurrentTimeOfDayIsAbout {TargetTimeOfDay WithinInterval {Option BothExclusive}} {

     if {![IsTimeOfDay $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetTimeOfDay $TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
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
     set CommandString "clock scan \"[Today] $TargetTimeOfDay\" -format $GenNS::DatetimeFormat"
     set TargetTimeSeconds [eval $CommandString]
     # Convert time interval to seconds
     set TotalScanned [scan $WithinInterval "%dH %dM %dS" WithinHours WithinMinutes WithinSeconds]
     if {$TotalScanned != 3} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) WithinInterval      $WithinInterval] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set IntervalTotalSeconds [expr ($WithinHours * 60 * 60) + ($WithinMinutes * 60) + $WithinSeconds]
     # Add and subtract
     set EarliestTime [expr $TargetTimeSeconds - $IntervalTotalSeconds]
     set LatestTime [expr $TargetTimeSeconds + $IntervalTotalSeconds]

     # Get current time of day in seconds
     set CurrentTimeOfDayInSeconds [clock seconds]

     # See if that is between the earliest and latest times
     if {[expr ($EarliestTime $Sign1 $CurrentTimeOfDayInSeconds) && ($CurrentTimeOfDayInSeconds $Sign2 $LatestTime)]} {
          return 1
     } else {
          return 0
     }
}