set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DividesEvenly not loaded because missing packages: $::GenMissingPackages."

     proc DividesEvenly {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DividesEvenly {Numerator Denominator} {

     return [expr $Numerator % $Denominator == 0]
}