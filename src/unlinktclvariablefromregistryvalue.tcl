set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/todoublebackslashes.tcl

if {[catch {package require registry}]} {
     lappend ::GenMissingPackages registry
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UnlinkTclVariableFromRegistryValue not loaded because missing packages: $::GenMissingPackages."

     proc UnlinkTclVariableFromRegistryValue {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UnlinkTclVariableFromRegistryValue {VarName RegistryKeyPath {RegistryValueName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryKeyPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryKeyPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryValueName]} {
          set RegistryValueName $VarName
     }

     set RegistryValueType [registry type $RegistryKeyPath $RegistryValueName]

     uplevel 1 "trace remove variable $VarName write \"UpdateRegistryValue $VarName {[ToDoubleBackslashes $RegistryKeyPath]} $RegistryValueType {$RegistryValueName}\""
}