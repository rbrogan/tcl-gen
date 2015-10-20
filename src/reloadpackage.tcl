proc ReloadPackage {Name {Version ""}} {

     if {[IsEmpty $Version]} {
          package forget $Name
          package require $Name
     } else {
          package forget $Name
          package require -exact $Name $Version
     }
}