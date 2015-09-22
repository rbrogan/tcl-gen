set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Flip not loaded because missing packages: $::GenMissingPackages."

     proc Flip {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Flip TargetVariable {
     if {[string first @ $TargetVariable] == 0} {
          UpvarExistingOrDie [string range $TargetVariable 1 end] Target
     } else {
          set Target $TargetVariable
     }

     if {[IsNonNumeric $Target]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Target] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     } elseif {$Target == 1} {
          set Target 0
     } elseif {$Target == 0} {
          set Target 1
     } else {
          error [format $::ErrorMessage(INPUT_OUT_OF_RANGE) $Target] $::errorInfo $::ErrorCode(INPUT_OUT_OF_RANGE)      
     }
}