proc MultiplyHhmmss {TimeVariable Multiplier} {
     if {[string first @ $TimeVariable] == 0} {
          UpvarExistingOrDie [string range $TimeVariable 1 end] Time
     } else {
          set Time $TimeVariable
     }

     if {[IsEmpty $Time]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TimeVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Multiplier]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Multiplier] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $Time]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeVariable $Time] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Multiplier]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Multiplier $Multiplier] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Seconds [Hhmmss2Seconds $Time]
     set Product [tcl::mathfunc::round [expr $Seconds * $Multiplier]]
     set Time [Seconds2Hhmmss $Product]
}