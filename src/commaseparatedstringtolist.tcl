proc CommaSeparatedStringToList StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set Stage1 [split $String ","]
     set Stage2 {}
     foreach Element $Stage1 {
          lappend Stage2 [string trim $Element]
     }
     set String $Stage2
}