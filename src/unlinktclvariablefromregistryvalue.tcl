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