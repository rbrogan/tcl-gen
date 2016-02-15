proc FindNearestSucceedingRecurrence {TargetDatetime RecurrenceStartDatetime RecurrenceIntervalLength} {

     if {![IsDatetime $TargetDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetDatetime $TargetDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $RecurrenceStartDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) RecurrenceStartDatetime $RecurrenceStartDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetimeQuantity $RecurrenceIntervalLength]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) RecurrenceIntervalLength $RecurrenceStartDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set TargetSeconds [eval "clock scan {$TargetDatetime} -format $GenNS::DatetimeFormat"]
     set StartSeconds [eval "clock scan {$RecurrenceStartDatetime} -format $GenNS::DatetimeFormat"]
     set IntervalLengthSeconds [DatetimeQuantity2Seconds $RecurrenceIntervalLength]
     if {$IntervalLengthSeconds <= 0} {
          error [format $::ErrorMessage(INPUT_NON_POSITIVE) $RecurrenceIntervalLength] $::errorInfo $::ErrorCode(INPUT_NON_POSITIVE)
     }

     if {$TargetSeconds <= $StartSeconds} {
          for {set TestSeconds $StartSeconds} {$TargetSeconds < $TestSeconds} {Decr TestSeconds $IntervalLengthSeconds} {
          }
          incr TestSeconds $IntervalLengthSeconds
     } else {
          for {set TestSeconds $StartSeconds} {$TestSeconds < $TargetSeconds} {incr TestSeconds $IntervalLengthSeconds} {
          }
     }

     return [eval "clock format $TestSeconds -format $GenNS::DatetimeFormat"]
}