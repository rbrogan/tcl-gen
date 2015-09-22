set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/notempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "RestoreWorkingDirectory not loaded because missing packages: $::GenMissingPackages."

     proc RestoreWorkingDirectory {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc RestoreWorkingDirectory {} {

     if {[NotEmpty $GenNS::SavedWorkingDirectory]} {
          cd $GenNS::SavedWorkingDirectory
     }

     return $GenNS::SavedWorkingDirectory
}