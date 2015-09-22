set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/ishhmmss.tcl

source $PackageRoot/startswith.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Hhmmss2Seconds not loaded because missing packages: $::GenMissingPackages."

     proc Hhmmss2Seconds {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Hhmmss2Seconds StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[IsEmpty $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) StringVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) StringVariable $String] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Flag 0
     if {[StartsWith $String "-"]} {
          set String [string range $String 1 end]
          set Flag 1
     }
     regexp {^(\d\d\d*):(\d\d)\:(\d\d)$} $String All Hours Minutes Seconds
     set String [expr $Seconds + ($Minutes * 60) + ($Hours * 60 * 60)]
     if {$Flag} {
          set String "-[set String]"
     }
     return $String
}