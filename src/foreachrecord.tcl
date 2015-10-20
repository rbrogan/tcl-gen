proc ForeachRecord {FieldNameList SelectStatement Body} {

     if {[IsEmpty $FieldNameList]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FieldNameList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $SelectStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SelectStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set Results [QQ $SelectStatement]
     uplevel "foreach {$FieldNameList} {$Results} {$Body}"
}