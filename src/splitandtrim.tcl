proc SplitAndTrim {StringVariable {SplitValue " "} {TrimValue " "}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set OutList {}
     foreach Element [split $String $SplitValue] {
          set Trimmed [string trim $Element $TrimValue]
          if {[NotEmpty $Trimmed]} {
               lappend OutList $Trimmed
          }
     }
     set String $OutList
}