set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UpdateDbGlobal not loaded because missing packages: $::GenMissingPackages."

     proc UpdateDbGlobal {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UpdateDbGlobal {VarName DbGlobalName args} {

     upvar #0 $VarName Var     
     SetDbGlobal $DbGlobalName $Var
}