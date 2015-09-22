set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FindAndRemove not loaded because missing packages: $::GenMissingPackages."

     proc FindAndRemove {VarName Value} "error \"$::GenPackageWarning\""

     return
}


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