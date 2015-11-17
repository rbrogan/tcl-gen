proc CurrentTimeOfDayIsBetween {EarlierTimeOfDay LaterTimeOfDay {Option BothExclusive}} {

     if {![IsTimeOfDay $EarlierTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) EarlierTimeOfDay $EarlierTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {![IsTimeOfDay $LaterTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) LaterTimeOfDay $LaterTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [TimeOfDayIsBetween [CurrentTimeOfDay] $EarlierTimeOfDay $LaterTimeOfDay $Option]
}