set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "GuessPackageRootDirectory not loaded because missing packages: $::GenMissingPackages."

     proc GuessPackageRootDirectory {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc GuessPackageRootDirectory {PackageName PackageVersion} {

     return [file dirname [lindex [package ifneeded $PackageName $PackageVersion]  1]]
}