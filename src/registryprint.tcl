proc RegistryPrint RegistryKeyPath {

     if {![RegistryExists $RegistryKeyPath]} {
          error [format $::ErrorMessage(REGISTRY_ELEMENT_NOT_FOUND) $RegistryKeyPath] $::errorInfo $::ErrorCode(REGISTRY_ELEMENT_NOT_FOUND)
     }

     set Dict [RegistryTree2Dict $RegistryKeyPath]
     PrintDict $Dict

}