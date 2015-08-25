proc IsDatetime StringValue {

     set CommandString "clock scan {$StringValue} -format $GenNS::DatetimeFormat"
     if {[catch $CommandString Temp]} {
          return 0
     } else {
          return 1
     }
}