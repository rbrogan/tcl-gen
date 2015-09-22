set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SetTimeOfDayFormat not loaded because missing packages: $::GenMissingPackages."

     proc SetTimeOfDayFormat {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SetTimeOfDayFormat FormatString {

     if {[catch {eval "clock format 0 -format $FormatString"} Result]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     } elseif {[string equal $Result $FormatString]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set GenNS::TimeOfDayFormat $FormatString
}