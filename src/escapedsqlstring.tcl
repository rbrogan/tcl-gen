set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "EscapedSqlString not loaded because missing packages: $::GenMissingPackages."

     proc EscapedSqlString {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc EscapedSqlString StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     # Replace all single quotes in the string with double quotes and return the value.
     set String [regsub -all {'} $String {''}]
}