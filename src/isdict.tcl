set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsDict not loaded because missing packages: $::GenMissingPackages."

     proc IsDict {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsDict StringValue {

          if {![catch {dict size $StringValue}]} {
               return 1
          } else {
               return 0
          }
}