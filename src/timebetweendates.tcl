proc TimeBetweenDates {FirstDate SecondDate} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Scan inputs, convert to seconds
     set FirstSeconds [eval "clock scan {$FirstDate} -format $GenNS::DateFormat"]
     set SecondSeconds [eval "clock scan {$SecondDate} -format $GenNS::DateFormat"]

     # Do subtraction
     set Result [expr abs($FirstSeconds - $SecondSeconds)]

     # Convert Seconds2DateQuantity
     return [Seconds2DateQuantity $Result]
}