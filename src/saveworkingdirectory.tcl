set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SaveWorkingDirectory not loaded because missing packages: $::GenMissingPackages."

     proc SaveWorkingDirectory {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SaveWorkingDirectory {} {

     set GenNS::SavedWorkingDirectory [pwd]
}