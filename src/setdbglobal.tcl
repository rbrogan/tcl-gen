proc SetDbGlobal {VarName {Value "DoGetDbGlobal"}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {$Value eq "DoGetDbGlobal"} {
          return [GetDbGlobal $VarName]
     } elseif {[IsEmpty $Value]} {
          # Enter an empty string as empty text value with nulls for intvalue and realvalue.
          RunSqlEnter $GenNS::GlobalsTable [dict create desc "'$VarName'"] [dict create textvalue "''" intvalue null realvalue null]
     } elseif {[string is double $Value]} {
          # If it is a double then for the intvalue, enter a truncated value.
          RunSqlEnter $GenNS::GlobalsTable [dict create desc '$VarName'] [dict create realvalue $Value intvalue [::tcl::mathfunc::floor $Value] textvalue '$Value']
     } elseif {[string is integer $Value]} {
          # If it is an integer then for the realvalue add ".0"
          RunSqlEnter $GenNS::GlobalsTable [dict create "desc '$VarName'"] [dict create intvalue $Value realvalue [set Value].0 textvalue "'$Value'"]
     } else {
          # Any other string enter as text with the intvalue and realvalue as null.
          RunSqlEnter $GenNS::GlobalsTable [dict create desc '$VarName'] [dict create textvalue "'$Value'" intvalue null realvalue null]
     }

     return $Value
}