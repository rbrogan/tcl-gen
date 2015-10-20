proc IsTimeOfDay StringValue {

     if {[catch {eval "clock scan {$StringValue} -format $GenNS::TimeOfDayFormat"}]} {
          return 0
     } else {
          return 1
     }
}