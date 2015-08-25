proc IsMatrix ListValue {

     set TargetLength [llength [lindex $ListValue 0]]
     foreach Element $ListValue {
          if {[llength $Element] != $TargetLength} {
               return 0
          }
     }

     return 1

}