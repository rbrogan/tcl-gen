set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsNonNumeric not loaded because missing packages: $::GenMissingPackages."

     proc IsNonNumeric {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsNonNumeric StringValue {

     if {[IsEmpty $StringValue]} {
          return 1
     } elseif {[string is integer $StringValue]} {
          return 0
     } elseif {[string is double $StringValue]} {
          return 0
     } elseif {[string is wideinteger $StringValue]} {
          return 0
     } else {
          return 1
     }
}