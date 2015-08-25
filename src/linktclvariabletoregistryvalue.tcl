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