proc DecrDbGlobal {VarName {Amount 1}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Try to get the value, and if it does not exist then make it zero.
     if {[SqlRecordExists $GenNS::GlobalsTable "desc '$VarName'"]} {
          set sql "SELECT textvalue FROM $GenNS::GlobalsTable WHERE desc = \"$VarName\""               
          set CurrentValue [Q1 $sql]
     } else {
          set CurrentValue 0
     }
          
     if {[IsNonNumeric $CurrentValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $CurrentValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Amount]} {
          error [format "Amount is invalid. $::ErrorMessage(INPUT_NON_NUMERIC)" $Amount] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }

     # Decrement the value by 1 and write it back to the database
     set NewValue [expr $CurrentValue - $Amount]
     SetDbGlobal $VarName $NewValue

     # Return the now-current value.
     return $NewValue
}