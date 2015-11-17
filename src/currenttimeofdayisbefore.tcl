proc CurrentTimeOfDayIsBefore TargetTimeOfDay {

     if {![IsTimeOfDay $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetTimeOfDay $TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [TimeOfDayIsBefore [CurrentTimeOfDay] $TargetTimeOfDay]
}