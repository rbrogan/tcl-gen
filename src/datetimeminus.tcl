proc DatetimeMinus {DatetimeVariable TimeAmount} {
     if {[string first @ $DatetimeVariable] == 0} {
          UpvarExistingOrDie [string range $DatetimeVariable 1 end] Datetime
     } else {
          set Datetime $DatetimeVariable
     }

     if {![IsDatetime $Datetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DatetimeVariable $Datetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Convert to negatives and call DatetimePlus.
     set ScanCount [scan $TimeAmount "%dY %dM %dW %dD %dH %dM %dS" YearsSubtracted MonthsSubtracted WeeksSubtracted DaysSubtracted HoursSubtracted MinutesSubtracted SecondsSubtracted]
     if {$ScanCount != 7} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeAmount $TimeAmount] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set TimeAmount [format "%dY %dM %dW %dD %dH %dM %dS" [expr $YearsSubtracted * -1] [expr $MonthsSubtracted * -1] [expr $WeeksSubtracted * -1] [expr $DaysSubtracted * -1] [expr $HoursSubtracted * -1] [expr $MinutesSubtracted * -1] [expr $SecondsSubtracted * -1]]
     set Datetime [DatetimePlus $Datetime $TimeAmount]
}