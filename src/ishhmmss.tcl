set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsHhmmss not loaded because missing packages: $::GenMissingPackages."

     proc IsHhmmss {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsHhmmss StringValue {

     if {[regexp {^-?(\d\d\d*):(\d\d)\:(\d\d)$} $StringValue All Hours Minutes Seconds]} {
          if {$Minutes >= 60} {
               return 0
          } elseif {$Seconds >= 60} {
               return 0
          } else {
               return 1
          }
     } else {
          return 0
     }
}