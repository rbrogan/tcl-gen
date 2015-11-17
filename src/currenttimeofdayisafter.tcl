proc CurrentTimeOfDayIsAfter TargetTimeOfDay {

     if {![IsTimeOfDay $TargetTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TargetTimeOfDay $TargetTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [TimeOfDayIsAfter [CurrentTimeOfDay] $TargetTimeOfDay]
}