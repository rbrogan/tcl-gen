proc FindAndRemove {ListVariable FindValue} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }


     while {[set Index [lsearch $List $FindValue]] != -1} {
          set List [lreplace $List $Index $Index]
     }
     return $List
}