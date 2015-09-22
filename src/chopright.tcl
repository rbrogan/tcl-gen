set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "ChopRight not loaded because missing packages: $::GenMissingPackages."

     proc ChopRight {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc ChopRight {StringVariable {Count 1}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {![string is integer $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }

     set String [string range $String 0 end-$Count]
}