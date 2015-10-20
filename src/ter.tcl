proc Ter {Condition IfTrue IfFalse} {

     set Result [uplevel 1 "expr {$Condition}"]
     if {$Result} {
          return [uplevel 1 "$IfTrue"]
     } else {
          return [uplevel 1 "$IfFalse"]
     }
}