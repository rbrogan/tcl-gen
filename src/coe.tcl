proc Coe args {

     set OutString ""
     foreach arg $args {
          if {[IsEmpty $arg]} {
               return ""
          } else {
               append OutString $arg
          }
     }
     return $OutString
}