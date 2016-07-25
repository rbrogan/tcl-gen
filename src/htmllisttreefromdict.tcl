proc HtmlListTreeFromDict {DictValue {IndentationSpaces 5} {IndentationLevel 0}} {

     if {![IsDict $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DictValue $DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsEmpty $IndentationSpaces]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) IndentationSpaces] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsNonNumeric $IndentationSpaces]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) IndentationSpaces $IndentationSpaces] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsEmpty $IndentationLevel]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) IndentationLevel] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsNonNumeric $IndentationLevel]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) IndentationLevel $IndentationLevel] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {$IndentationLevel == 0} {
          append OutString "<ul>\n"
     }

     dict for {Node Child} $DictValue {
          if {[IsDict $Child]} {
               append OutString "[string repeat " " [expr ($IndentationLevel + 1) * $IndentationSpaces]]<li>$Node\n"
               append OutString "[string repeat " " [expr ($IndentationLevel + 2) * $IndentationSpaces]]<ul>\n[HtmlListTreeFromDict $Child $IndentationSpaces [expr $IndentationLevel + 2]]"
               append OutString "[string repeat " " [expr ($IndentationLevel + 2) * $IndentationSpaces]]</ul>\n"
               append OutString "[string repeat " " [expr ($IndentationLevel + 1) * $IndentationSpaces]]</li>\n"
          } else {
               append OutString "[string repeat " " [expr ($IndentationLevel + 1) * $IndentationSpaces]]<li>"
               append OutString "$Node: $Child"
               append OutString "</li>\n"
          }
     }

     if {$IndentationLevel == 0} {
          append OutString "</ul>\n"
     }     
     
     return $OutString
}