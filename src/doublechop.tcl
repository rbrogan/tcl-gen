set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/chopleft.tcl

source $PackageRoot/chopright.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DoubleChop not loaded because missing packages: $::GenMissingPackages."

     proc DoubleChop {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DoubleChop {StringVariable {Count 1}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [ChopRight [ChopLeft $String $Count] $Count]

}