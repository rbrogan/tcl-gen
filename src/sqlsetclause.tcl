proc SqlSetClause DictValue {

     if {[IsEmpty $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set SetClause ""
     set Flag 0
     dict for {Key Value} $DictValue {
          if {$Flag != 0} {
               append SetClause ", "
          } else {
               set Flag 1
          }
          append SetClause "$Key = $Value"
     }
     
     return $SetClause
}