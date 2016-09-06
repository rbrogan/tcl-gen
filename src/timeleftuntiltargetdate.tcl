proc TimeLeftUntilTargetDate TargetDate {

     if {![IsDate $TargetDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetDate $TargetDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[DateIsBefore $TargetDate [Today]]} {
          return "-[TimeBetweenDates [eval "clock format [clock seconds] -format $GenNS::DateFormat"] $TargetDate]"
     } else {
          return [TimeBetweenDates [eval "clock format [clock seconds] -format $GenNS::DateFormat"] $TargetDate]
     }
}