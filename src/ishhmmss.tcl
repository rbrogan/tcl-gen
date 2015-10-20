proc IsHhmmss StringValue {

     if {[regexp {^-?(\d\d\d*):(\d\d)\:(\d\d)$} $StringValue All Hours Minutes Seconds]} {
          if {$Minutes >= 60} {
               return 0
          } elseif {$Seconds >= 60} {
               return 0
          } else {
               return 1
          }
     } else {
          return 0
     }
}