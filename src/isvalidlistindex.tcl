proc IsValidListIndex {ListValue Index} {

     if {![string is integer $Index]} {
          return 0
     } elseif {[IsNegative $Index]} {
          return 0
     } elseif {[llength $ListValue] <= $Index} {
          return 0
     } else {
          return 1
     }
}