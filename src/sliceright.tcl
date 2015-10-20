proc SliceRight {TargetString Characters} {

     set List {}
     set Left -1
     set Right -1
     for {set i 0} {$i < [string length $TargetString]} {incr i} {
          # Check whether the current character is one of the match characters
          set Result [string first [string index $TargetString $i] $Characters]
          if {$Result >= 0} {
               # Found one
               # Because we are cutting to the right, 
               # the found character will be end of current string
               # next character will be start of next string,

               set Right $i
               if {$Right == -1} {
                    # Hit it on first index
                    lappend List [string range $TargetString 0 0]
                    set Left 1
               } else {
                    lappend List [string range $TargetString $Left $Right]
                    set Left [expr $i + 1]
               }
          }
     }
          
     if {($Left == -1) && ($Right == -1)} {
          # Nothing found
          return $TargetString     
     } elseif {($Right != [expr [string length $TargetString] - 1])} {
          lappend List [string range $TargetString $Left [expr [string length $TargetString] - 1]]
     } 
     
     return $List
}