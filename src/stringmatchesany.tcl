proc StringMatchesAny {PatternList String} {

     foreach Pattern $PatternList {
          if {[string match $Pattern $String]} {
               return 1
          }
     }

     return 0
}