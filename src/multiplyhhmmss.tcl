set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/ishhmmss.tcl

source $PackageRoot/isnonnumeric.tcl

source $PackageRoot/hhmmss2seconds.tcl

source $PackageRoot/seconds2hhmmss.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "MultiplyHhmmss not loaded because missing packages: $::GenMissingPackages."

     proc MultiplyHhmmss {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc MultiplyHhmmss {TimeVariable Multiplier} {
     if {[string first @ $TimeVariable] == 0} {
          UpvarExistingOrDie [string range $TimeVariable 1 end] Time
     } else {
          set Time $TimeVariable
     }

     if {[IsEmpty $Time]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TimeVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Multiplier]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Multiplier] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $Time]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeVariable $Time] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Multiplier]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Multiplier $Multiplier] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Seconds [Hhmmss2Seconds $Time]
     set Product [tcl::mathfunc::round [expr $Seconds * $Multiplier]]
     set Time [Seconds2Hhmmss $Product]
}