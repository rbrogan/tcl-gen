proc IncludeExcludeListFilter {ListVariable IncludePatternList ExcludePatternList} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     set OutList {}

     foreach Element $List {
          if {[StringMatchesAny $IncludePatternList $Element] && ![StringMatchesAny $ExcludePatternList $Element]} {
               lappend OutList $Element
          }
     }

     set List $OutList

     return $List
}