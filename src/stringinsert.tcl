set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/isnonnumeric.tcl

source $PackageRoot/isnegative.tcl

source $PackageRoot/ispositive.tcl

source $PackageRoot/ter.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "StringInsert not loaded because missing packages: $::GenMissingPackages."

     proc StringInsert {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc StringInsert {StringVariable InsertValue WhereAt} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[IsEmpty $WhereAt]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereAt] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {$WhereAt eq "end"} {
          set WhereAt [expr [string length $String] - 1]
     }

     if {[IsNonNumeric $WhereAt]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) WhereAt $WhereAt] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }

     if {[IsNegative $WhereAt]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) WhereAt $WhereAt] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstPart [string range $String 0 [expr $WhereAt - 1]]
     set LastPart [string range $String $WhereAt end]
     set IndexDifference [expr $WhereAt - [string length $String]]
     set Spaces [string repeat " " [Ter [IsPositive $IndexDifference] {return $IndexDifference} {return 0}]]
     set String "[set FirstPart][set Spaces][set InsertValue][set LastPart]"
}