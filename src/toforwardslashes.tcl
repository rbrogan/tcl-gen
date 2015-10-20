proc ToForwardSlashes StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [regsub -all {\\\\} $String /]
     set String [regsub -all {\\} $String /]
     return $String
}