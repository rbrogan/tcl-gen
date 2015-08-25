proc LappendIfNotAlready {ListVarName Values} {

     UpvarX $ListVarName List
     foreach Value $Values {
          if {[lsearch $List $Value] == -1} {
               lappend List $Value
          }
     }
     return $List
}