set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Mash not loaded because missing packages: $::GenMissingPackages."

     proc Mash {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Mash StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [string tolower [join $String ""]]
}