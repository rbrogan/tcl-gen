proc LastMonth {{{Format %m}}} {

     if {[lsearch [list %m %b %B] $Format] == -1} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Format $Format] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set CurrentMonth [eval "clock format [clock seconds] -format $Format"]
     if {$CurrentMonth == 0} {
          set LastMonth 12
     }
     set LastMonth [incr CurrentMonth -1]

     return $LastMonth
}