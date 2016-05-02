proc TimeBetweenTimesOfDay {FirstTimeOfDay SecondTimeOfDay} {

     if {[IsEmpty $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {![IsHhmmss $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Convert each to seconds
     set FirstTimeOfDayInSeconds [Hhmmss2Seconds $FirstTimeOfDay]
     set SecondTimeOfDayInSeconds [Hhmmss2Seconds $SecondTimeOfDay]

     # Find the difference
     set DifferenceSeconds [expr "abs($SecondTimeOfDayInSeconds - $FirstTimeOfDayInSeconds)"]

     # Convert into a time quantity string
     set TimeQuantityHours [expr "$DifferenceSeconds / (60 * 60)"]
     set DifferenceSeconds [expr "$DifferenceSeconds % (60 * 60)"]
     set TimeQuantityMinutes [expr "$DifferenceSeconds / 60"]
     set TimeQuantitySeconds [expr "$DifferenceSeconds % 60"]
     set DifferenceTimeQuantity [format "%dH %dM %dS" $TimeQuantityHours $TimeQuantityMinutes $TimeQuantitySeconds]
     
     return $DifferenceTimeQuantity
}