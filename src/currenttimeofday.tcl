proc CurrentTimeOfDay {} {

     return [eval "clock format [clock seconds] -format $GenNS::TimeOfDayFormat"]
}