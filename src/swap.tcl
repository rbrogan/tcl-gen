set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarx.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Swap not loaded because missing packages: $::GenMissingPackages."

     proc Swap {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Swap {VarNameA VarNameB} {

     UpvarX $VarNameA A
     UpvarX $VarNameB B
     set Temp $A
     set A $B
     set B $Temp
     return
}