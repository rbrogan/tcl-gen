proc StringContains {TargetString SearchValue} {

     if {[string first $SearchValue $TargetString] != -1} {
          return 1
     } else {
          return 0
     }
}