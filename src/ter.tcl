set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Ter not loaded because missing packages: $::GenMissingPackages."

     proc Ter {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Ter {Condition IfTrue IfFalse} {

     set Result [uplevel 1 "expr {$Condition}"]
     if {$Result} {
          return [uplevel 1 "$IfTrue"]
     } else {
          return [uplevel 1 "$IfFalse"]
     }
}