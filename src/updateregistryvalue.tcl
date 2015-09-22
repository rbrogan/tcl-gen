set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UpdateRegistryValue not loaded because missing packages: $::GenMissingPackages."

     proc UpdateRegistryValue {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UpdateRegistryValue {VarName RegistryKeyPath RegistryValueType {RegistryValueName ""} args} {

     if {[IsEmpty $RegistryValueName]} {
          set RegistryValueName $VarName
     }
     upvar #0 $VarName Var     
     registry set $RegistryKeyPath $RegistryValueName $Var $RegistryValueType
}