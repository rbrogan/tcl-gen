proc DatetimeQuantity2Seconds DatetimeQuantity {

     if {[IsEmpty $DatetimeQuantity]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DatetimeQuantity $DatetimeQuantity] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set Flag 0
     if {[StartsWith $DatetimeQuantity "-"]} {
          set DatetimeQuantity [string range $DatetimeQuantity 1 end]
          set Flag 1
     }

     set ScanCount [scan $DatetimeQuantity "%04dT%02d:%02d:%02d" Days Hours Minutes Seconds]
     if {$ScanCount != 4} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DatetimeQuantity $DatetimeQuantity] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set TotalSeconds [expr $Seconds + ($Minutes * 60) + ($Hours * 60 * 60) + ($Days * 24 * 60 * 60)]

     if {$Flag} {
          set TotalSeconds "-[set TotalSeconds]"
     }

     return $TotalSeconds
}