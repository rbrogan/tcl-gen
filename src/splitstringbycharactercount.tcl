proc SplitStringByCharacterCount {String CharacterCount} {

     set OutList {}

     while {[string length $String] > $CharacterCount} {
          set CurrentIndex $CharacterCount
          set CurrentCharacter {}
          set Done 0
          while {!$Done} {
               set PreviousCharacter $CurrentCharacter
               set CurrentCharacter [string index $String $CurrentIndex]
               if {($CurrentCharacter eq "\n") && ($PreviousCharacter eq "\n")} {
                    set Done 1
                    lappend OutList [string range $String 0 [expr $CurrentIndex - 1]]
                    set String [string range $String [expr $CurrentIndex + 1] end]
                    # Trim the whitespace off the front of string
                    set String [regsub ^(\\s+) $String {}]
               } else {
                    Decr CurrentIndex
               }
          }
     }
     lappend OutList $String

     return $OutList
}