set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "ReloadPackage not loaded because missing packages: $::GenMissingPackages."

     proc ReloadPackage {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc ReloadPackage {Name {Version ""}} {

     if {[IsEmpty $Version]} {
          package forget $Name
          package require $Name
     } else {
          package forget $Name
          package require -exact $Name $Version
     }
}