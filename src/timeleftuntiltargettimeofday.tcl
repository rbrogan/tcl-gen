proc TimeLeftUntilTargetTimeOfDay TargetTimeOfDay {

     if {[IsEmpty $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsTimeOfDay $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetTimeOfDay $TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Get current time-of-day
     set CurrentTimeOfDay [CurrentTimeOfDay]

     # Find distance to target time-of-day
     set TimeLeft [TimeBetweenTimesOfDay $CurrentTimeOfDay $TargetTimeOfDay]

     # If current time-of-day is after the target, then prefix with a negative sign
     if {[TimeOfDayIsAfter $CurrentTimeOfDay $TargetTimeOfDay]} {
          Prepend TimeLeft "-"
     }

     return $TimeLeft
}