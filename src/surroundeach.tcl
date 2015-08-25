proc SurroundEach {ListVariable String} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     set OutList {}
     foreach Element $List {
          lappend OutList "[set String][set Element][set String]"
     }
     set List $OutList
}