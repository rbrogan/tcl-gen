proc DatetimeIsBefore {FirstDatetime SecondDatetime} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }


     set FirstSeconds [eval "clock scan {$FirstDatetime} -format $GenNS::DatetimeFormat"]
     set SecondSeconds [eval "clock scan {$SecondDatetime} -format $GenNS::DatetimeFormat"]
     if {$SecondSeconds > $FirstSeconds} {
          return 1
     } else {
          return 0
     }
}