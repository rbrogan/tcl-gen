set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsDirectoryEmpty not loaded because missing packages: $::GenMissingPackages."

     proc IsDirectoryEmpty {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsDirectoryEmpty TargetDirectoryPath {

     return [IsEmpty [glob -nocomplain -directory $TargetDirectoryPath *]]
}