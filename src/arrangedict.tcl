set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "ArrangeDict not loaded because missing packages: $::GenMissingPackages."

     proc ArrangeDict {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc ArrangeDict {DictVariable Arrangement} {
     if {[string first @ $DictVariable] == 0} {
          UpvarExistingOrDie [string range $DictVariable 1 end] Dict
     } else {
          set Dict $DictVariable
     }

     set Out [dict create]
     for {set i 0} {$i < [llength $Arrangement]} {incr i} {
          set Key [lindex $Arrangement $i]
          if {[dict exists $Dict $Key]} {
               dict set Out $Key [dict get $Dict $Key]
          }
     }
     
     set Dict $Out
}