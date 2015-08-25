proc StringMid {TargetString Position {Count -1}} {

     if {[IsNonNumeric $Count]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Count] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }      

     if {$Count != -1} {
          if {[IsNonPositive $Count]} {
               error [format $::ErrorMessage(INPUT_NON_POSITIVE) $Count] $::errorInfo $::ErrorCode(INPUT_NON_POSITIVE)          
          }    
          if {$Position < 0} {
               set Position 0
          }
          return [string range $TargetString $Position [expr $Position + $Count - 1]]
     } else {
          return [string range $TargetString $Position end]
     }
}