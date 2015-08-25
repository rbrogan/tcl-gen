proc IsNonNumeric StringValue {

     if {[IsEmpty $StringValue]} {
          return 1
     } elseif {[string is integer $StringValue]} {
          return 0
     } elseif {[string is double $StringValue]} {
          return 0
     } elseif {[string is wideinteger $StringValue]} {
          return 0
     } else {
          return 1
     }
}