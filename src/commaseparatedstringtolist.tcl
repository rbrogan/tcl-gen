set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "CommaSeparatedStringToList not loaded because missing packages: $::GenMissingPackages."

     proc CommaSeparatedStringToList {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc CommaSeparatedStringToList StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set Stage1 [split $String ","]
     set Stage2 {}
     foreach Element $Stage1 {
          lappend Stage2 [string trim $Element]
     }
     set String $Stage2
}