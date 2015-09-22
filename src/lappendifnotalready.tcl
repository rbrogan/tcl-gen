set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarx.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "LappendIfNotAlready not loaded because missing packages: $::GenMissingPackages."

     proc LappendIfNotAlready {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc LappendIfNotAlready {ListVarName Values} {

     UpvarX $ListVarName List
     foreach Value $Values {
          if {[lsearch $List $Value] == -1} {
               lappend List $Value
          }
     }
     return $List
}