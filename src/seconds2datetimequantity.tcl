proc Seconds2DatetimeQuantity SecondsValue {

     if {[IsEmpty $SecondsValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SecondsValue $SecondsValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![string is integer $SecondsValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $SecondsValue SecondsValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {$SecondsValue < 0} {
          set SignPrefix "-"
          set SecondsValue [expr $SecondsValue * -1]
     } else {
          set SignPrefix ""
     }
     set Days [expr $SecondsValue / (24 * 60 * 60)]
     set SecondsValue [expr $SecondsValue % (24 * 60 * 60)]
     set Hours [expr $SecondsValue / (60 * 60)]
     set SecondsValue [expr $SecondsValue % (60 * 60)]
     set Minutes [expr $SecondsValue / 60]
     set Seconds [expr $SecondsValue % 60]
     return [format "[set SignPrefix]%02dT%02d:%02d:%02d" $Days $Hours $Minutes $Seconds]
}