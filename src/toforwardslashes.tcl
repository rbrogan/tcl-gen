set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "ToForwardSlashes not loaded because missing packages: $::GenMissingPackages."

     proc ToForwardSlashes {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc ToForwardSlashes StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [regsub -all {\\\\} $String /]
     set String [regsub -all {\\} $String /]
     return $String
}