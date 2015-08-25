proc EndsWith {StringValue SearchValue} {

     if {[IsEmpty $SearchValue]} {
          error $::ErrorMessage(SEARCH_STRING_EMPTY) $::errorInfo $::ErrorCode(SEARCH_STRING_EMPTY)
     }
     set LastStart [expr [string length $StringValue] - [string length $SearchValue]]
     set EndPart [string range $StringValue $LastStart end]
     if {[string equal $EndPart $SearchValue]} {
          return 1
     } else {
          return 0
     }
}