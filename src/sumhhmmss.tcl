proc SumHhmmss ListValue {

     for {set i 0} {$i < [llength $ListValue]} {incr i} {
          set Element [lindex $ListValue $i]
          if {![IsHhmmss $Element]} {
               error [format $::ErrorMessage(LIST_HAS_INVALID_ELEMENT) ListValue $i $Element] $::errorInfo $::ErrorCode(LIST_HAS_INVALID_ELEMENT)
          }
     }

     set TotalSeconds 0
     foreach Element $ListValue {
          set ElementSeconds [Hhmmss2Seconds $Element]
          AddTo TotalSeconds $ElementSeconds
     }
     
     return [Seconds2Hhmmss $TotalSeconds]
}