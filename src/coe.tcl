set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Coe not loaded because missing packages: $::GenMissingPackages."

     proc Coe {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Coe args {

     set OutString ""
     foreach arg $args {
          if {[IsEmpty $arg]} {
               return ""
          } else {
               append OutString $arg
          }
     }
     return $OutString
}