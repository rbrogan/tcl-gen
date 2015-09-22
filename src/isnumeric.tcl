set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsNumeric not loaded because missing packages: $::GenMissingPackages."

     proc IsNumeric {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsNumeric StringValue {

     if {[IsEmpty $StringValue]} {
          return 0
     } elseif {[string is integer $StringValue]} {
          return 1
     } elseif {[string is double $StringValue]} {
          return 1
     } elseif {[string is wideinteger $StringValue]} {
          return 1
     } else {
          return 0
     }
}