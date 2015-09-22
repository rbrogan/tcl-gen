set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarx.tcl

source $PackageRoot/registryexists.tcl

source $PackageRoot/todoublebackslashes.tcl

if {[catch {package require registry}]} {
     lappend ::GenMissingPackages registry
}

source $PackageRoot/updateregistryvalue.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "LinkTclVariableToRegistryValue not loaded because missing packages: $::GenMissingPackages."

     proc LinkTclVariableToRegistryValue {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc LinkTclVariableToRegistryValue {VarName RegistryKeyPath RegistryValueName} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryKeyPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryKeyPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryValueName]} {
          set ValueName $VarName
     }

     UpvarX $VarName Var
     if {[RegistryExists $RegistryKeyPath $RegistryValueName]} {
          set RegistryValueType [registry type $RegistryKeyPath $RegistryValueName]
     } else {
          set RegistryValueType sz
     }

     registry set $RegistryKeyPath $RegistryValueName $Var $RegistryValueType
     uplevel 1 "trace add variable $VarName write \"UpdateRegistryValue $VarName {[ToDoubleBackslashes $RegistryKeyPath]} $RegistryValueType {$RegistryValueName}\""
}