proc IsDate StringValue {

     if {[catch {eval "clock scan {$StringValue} -format $GenNS::DateFormat"}]} {
          return 0
     } else {
          return 1
     }
}