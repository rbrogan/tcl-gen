proc IsDatetimeQuantity DatetimeQuantity {

     if {[IsEmpty $DatetimeQuantity]} {
          return 0
     }

     if {[StartsWith $DatetimeQuantity "-"]} {
          set DatetimeQuantity [string range $DatetimeQuantity 1 end]
     }

     set ScanCount [scan $DatetimeQuantity "%04dT%02d:%02d:%02d" Days Hours Minutes Seconds]
     if {$ScanCount != 4} {
          return 0
     }

     return 1
}