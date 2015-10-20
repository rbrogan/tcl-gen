proc PrintDict {DictValue {IndentationSpaces 0}} {

     if {![IsDict $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DictValue $DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Create string full of spaces to indent
     set Spaces [string repeat " " $IndentationSpaces]

     # Make first pass to figure out the length of the greatest key
     set MaxKeyLength 0
     dict for {Key Value} $DictValue {
          set CurrentKeyLength [string length $Key]
          set MaxKeyLength [Ter {$CurrentKeyLength > $MaxKeyLength} {return $CurrentKeyLength} {return $MaxKeyLength}]
     }

     # Make another pass to print each key and value.
     dict for {Key Value} $DictValue {
          if {[IsDict $Value]} {
               # This is a dict so, print the key and recurse.
               puts [format "$Spaces%[set MaxKeyLength]s" $Key]
               # Add to the length the space needed for the largest key plus one.
               PrintDict $Value [expr $MaxKeyLength + $IndentationSpaces + 1]
          } else {
               # Otherwise, just print key and value on one line.
               puts [format "$Spaces%[set MaxKeyLength]s $Value" $Key]
          }
     }
}