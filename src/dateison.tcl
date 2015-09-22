set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isdate.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DateIsOn not loaded because missing packages: $::GenMissingPackages."

     proc DateIsOn {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DateIsOn {FirstDate SecondDate} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [string equal $FirstDate $SecondDate]
}