proc StartsAndEndsWith {TargetString SearchValue} {

     if {[StartsWith $TargetString $SearchValue] && [EndsWith $TargetString $SearchValue]} {
          return 1
     } else {
          return 0
     }
}