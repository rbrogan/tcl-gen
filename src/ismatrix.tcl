set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsMatrix not loaded because missing packages: $::GenMissingPackages."

     proc IsMatrix {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsMatrix ListValue {

     set TargetLength [llength [lindex $ListValue 0]]
     foreach Element $ListValue {
          if {[llength $Element] != $TargetLength} {
               return 0
          }
     }

     return 1

}