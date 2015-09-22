set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/registryexists.tcl

source $PackageRoot/registrytree2dict.tcl

source $PackageRoot/printdict.tcl

if {[catch {package require registry}]} {
     lappend ::GenMissingPackages registry
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "RegistryPrint not loaded because missing packages: $::GenMissingPackages."

     proc RegistryPrint {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc RegistryPrint RegistryKeyPath {

     if {![RegistryExists $RegistryKeyPath]} {
          error [format $::ErrorMessage(REGISTRY_ELEMENT_NOT_FOUND) $RegistryKeyPath] $::errorInfo $::ErrorCode(REGISTRY_ELEMENT_NOT_FOUND)
     }

     set Dict [RegistryTree2Dict $RegistryKeyPath]
     PrintDict $Dict

}