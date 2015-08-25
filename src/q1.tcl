proc Q1 QueryStatement {

     if {[IsEmpty $QueryStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) QueryStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     return [FirstOf [$GenNS::DatabaseName eval $QueryStatement]]
}