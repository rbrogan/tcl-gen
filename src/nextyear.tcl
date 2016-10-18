proc NextYear {{{Format %Y}}} {

     if {[lsearch [list %y %Y] $Format] == -1} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Format $Format] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [incr [eval "clock format [clock seconds] -format $Format"]]
}