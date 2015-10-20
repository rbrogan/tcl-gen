proc LimitLineLengthInFile {MaxLength InputFilePath {OutputFilePath ""}} {

     if {[IsNonPositive $MaxLength]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) MaxLength $MaxLength] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsEmpty $InputFilePath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) InputFilePath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $OutputFilePath]} {
          set OutputFilePath $InputFilePath
     }
     
     set InList [File2List $InputFilePath]
     set OutList {}

     foreach Element $InList { 
          if {[regexp {^(\s*)} $Element All Whitespace]} {
               if {[string length $Whitespace] != $MaxLength} {
                    lappend OutList "[set Whitespace][::textutil::adjust::adjust $Element -length [expr $MaxLength - [string length $Whitespace]] -strictlength true]"
               } else {
                    lappend OutList [::textutil::adjust::adjust $Element -length $MaxLength -strictlength true]
               }
          } else {
               lappend OutList [::textutil::adjust::adjust $Element -length $MaxLength -strictlength true]
          }
     }     
     List2File $OutList $OutputFilePath
     
     return ""
}