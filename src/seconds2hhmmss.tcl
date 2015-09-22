set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Seconds2Hhmmss not loaded because missing packages: $::GenMissingPackages."

     proc Seconds2Hhmmss {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Seconds2Hhmmss StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[IsEmpty $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) StringVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsNonNumeric $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) StringVariable $String] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Flag 0
     if {[expr $String < 0]} {
          set Flag 1
          set Seconds [expr $String * -1]
     } else {
          set Seconds $String
     }

     set Hours [expr $Seconds / 3600]
     set Temp [expr $Seconds % 3600]
     set Minutes [expr $Temp / 60]
     set Seconds [expr $Temp % 60]
     
     set Output [format "%02d:%02d:%02d" $Hours $Minutes $Seconds]
     if {$Flag} {
          set Output "-[set Output]"
     }
     return $Output
}