proc ListRemoveAt {ListVariable Index {Count 1}} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     if {[IsEmpty $List]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ListVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Index]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Index] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {$Index eq "end"} {
          set Index [expr [llength $List] - 1]
     }

     if {[IsNonNumeric $Index] || ($Index < 0) || ($Index > ([llength $List] - 1))} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Index $Index] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Count] || [IsNonPositive $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set List [lreplace $List $Index [expr $Index + $Count - 1]]
}