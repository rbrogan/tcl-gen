proc DateMinus {DateVariable TimeAmount} {
     if {[string first @ $DateVariable] == 0} {
          UpvarExistingOrDie [string range $DateVariable 1 end] Date
     } else {
          set Date $DateVariable
     }

     if {![IsDate $Date]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DateVariable $Date] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Convert to negatives and call DatePlus.
     set ScanCount [scan $TimeAmount "%dY %dM %dW %dD" YearsSubtracted MonthsSubtracted WeeksSubtracted DaysSubtracted]
     if {$ScanCount != 4} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeAmount $TimeAmount] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set TimeAmount [format "%dY %dM %dW %dD" [expr $YearsSubtracted * -1] [expr $MonthsSubtracted * -1] [expr $WeeksSubtracted * -1] [expr $DaysSubtracted * -1]]
     set Date [DatePlus $Date $TimeAmount]
}