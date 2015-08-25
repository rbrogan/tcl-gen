proc UpdateRegistryValue {VarName RegistryKeyPath RegistryValueType {RegistryValueName ""} args} {

     if {[IsEmpty $RegistryValueName]} {
          set RegistryValueName $VarName
     }
     upvar #0 $VarName Var     
     registry set $RegistryKeyPath $RegistryValueName $Var $RegistryValueType
}