proc RegistryTree2Dict {CurrentRegKey {CurrentDictName ""}} {

     if {[IsEmpty $CurrentRegKey]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) CurrentRegKey] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![RegistryExists $CurrentRegKey]} {
          error [format $::ErrorMessage(REGISTRY_ELEMENT_NOT_FOUND) $CurrentRegKey] $::errorInfo $::ErrorCode(REGISTRY_ELEMENT_NOT_FOUND)
     }

     set CurrentDict [dict create]

     # Go through each value in the current registry key.
     foreach RegValueName [registry values $CurrentRegKey] {
          # Get the data from the registry for the current value.
          set RegValueData [registry get $CurrentRegKey $RegValueName]
          # Add an entry to the current dict with the name and data of the value.
          dict set CurrentDict $RegValueName $RegValueData
     }

     # Go through each subkey under the current registry key.
     foreach RegKey [registry keys $CurrentRegKey] {
          # Recurse and get a dict.
          set DictValue [RegistryTree2Dict "$CurrentRegKey\\$RegKey"]
          # Add an entry to the current dict the with name of the subkey,
          # and the dict as the value
          dict set CurrentDict $RegKey $DictValue
     }
   
   
     return $CurrentDict
}