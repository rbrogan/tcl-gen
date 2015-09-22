set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SetDateFormat not loaded because missing packages: $::GenMissingPackages."

     proc SetDateFormat {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SetDateFormat FormatString {

     if {[catch {eval "clock format 0 -format $FormatString"} Result]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     } elseif {[string equal $Result $FormatString]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set GenNS::DateFormat $FormatString
}