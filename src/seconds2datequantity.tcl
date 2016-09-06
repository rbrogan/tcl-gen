proc Seconds2DateQuantity SecondsVariable {
     if {[string first @ $SecondsVariable] == 0} {
          UpvarExistingOrDie [string range $SecondsVariable 1 end] Seconds
     } else {
          set Seconds $SecondsVariable
     }

     return [expr $Seconds / (60*60*24)]
}