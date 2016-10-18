proc NextMonth {{{Format %m}}} {

     if {[lsearch [list %m %b %B] $Format] == -1} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Format $Format] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [incr [eval "clock format [clock seconds] -format $Format"]]
}