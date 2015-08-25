proc RegistryExists {KeyName {ValueName ""}} {

     if {[IsEmpty $KeyName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) KeyName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $ValueName]} {
          if {![catch {registry values $KeyName}]} {
               return 1
          } else {
               return 0
          }
     } else {
          if {![catch {registry get $KeyName $ValueName}]} {
               return 1
          } else {
               return 0
          }
     }
}