set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/ishhmmss.tcl

source $PackageRoot/hhmmss2seconds.tcl

source $PackageRoot/seconds2hhmmss.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DiffHhmmss not loaded because missing packages: $::GenMissingPackages."

     proc DiffHhmmss {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DiffHhmmss {MinuendVariable Subtrahend} {
     if {[string first @ $MinuendVariable] == 0} {
          UpvarExistingOrDie [string range $MinuendVariable 1 end] Minuend
     } else {
          set Minuend $MinuendVariable
     }

     if {[IsEmpty $Minuend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) MinuendVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Subtrahend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SubtrahendVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $Minuend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) MinuendVariable $MinuendVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsHhmmss $Subtrahend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Subtrahend $Subtrahend] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set A [Hhmmss2Seconds $Minuend]
     set B [Hhmmss2Seconds $Subtrahend]
     set Minuend [Seconds2Hhmmss [expr $A - $B]]
}