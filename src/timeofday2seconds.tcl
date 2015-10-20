proc TimeOfDay2Seconds StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[catch {eval "clock scan {$String} -format $GenNS::TimeOfDayFormat"} String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) StringVariable $StringVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     return $String
}