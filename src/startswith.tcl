proc StartsWith {TargetString SearchValue} {

     if {[string first $SearchValue $TargetString] == 0} {
          return 1
     } else {
          return 0
     }
}