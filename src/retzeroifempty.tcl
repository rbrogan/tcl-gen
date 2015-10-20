proc RetZeroIfEmpty Value {

     if {[IsEmpty $Value]} {
          return 0
     } else {
          return $Value
     }
}