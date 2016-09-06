proc TimeLeftUntilTargetDatetime TargetDatetime {

     if {![IsDatetime $TargetDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetDatetime $TargetDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[DatetimeIsBefore $TargetDatetime [Now]]} {
          return "-[TimeBetweenDatetimes [eval "clock format [clock seconds] -format $GenNS::DatetimeFormat"] $TargetDatetime]"
     } else {
          return [TimeBetweenDatetimes [eval "clock format [clock seconds] -format $GenNS::DatetimeFormat"] $TargetDatetime]
     }
}