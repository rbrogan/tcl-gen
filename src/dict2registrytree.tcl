proc Dict2RegistryTree {DictValue RegistryRootKey {DeleteUnmatchedOption --leave-unmatched}} {

     if {[IsEmpty $RegistryRootKey]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryRootKey] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsDict $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DictValue $DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     switch $DeleteUnmatchedOption {
          --leave-unmatched {
               set DeleteUnmatched 0
          }
          --delete-unmatched {
               set DeleteUnmatched 1
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DeleteUnmatchedOption $DeleteUnmatchedOption] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }

     registry set $RegistryRootKey

     # Iterate over the dict entries,
     # and make equivalent registry entries.
     dict for {Name Value} $DictValue {
          set FullName "$RegistryRootKey\\$Name"
          # Check if the value is itself a dict
          if {[IsDict $Value]} {
               # If so, make a subkey and recurse
               registry set $FullName
               Dict2RegistryTree $Value $FullName $DeleteUnmatchedOption
          } else {
               # If not, make a registry value.
               # If the value already exists, keep the same type.
               # If not, make it string type.
               if {[RegistryExists $RegistryRootKey $Name]} {
                    set Type [registry type $RegistryRootKey $Name]
                    registry set $RegistryRootKey $Name $Value $Type
               } else {
                    registry set $RegistryRootKey $Name $Value
               }
          }
     }
     
     # If option is set to delete unmatched elements,
     # go through and delete them.
     if {$DeleteUnmatched} {
          # If any keys/value are in the registry but not the dict,
          # delete them from the registry.
          foreach RegKey [registry keys $RegistryRootKey] {
               if {![dict exists $DictValue $RegKey]} {
                    registry delete "$RegistryRootKey\\$RegKey"
               }
          }
          
          foreach RegValueName [registry values $RegistryRootKey] {
               if {![dict exists $DictValue $RegValueName]} {
                    registry delete $RegistryRootKey $RegValueName
               }
          }
     }
}