proc File2List {InFilePath {ListVarName ""}} {

     if {[NotEmpty $ListVarName]} {
          upvar $ListVarName List
     }
     
     # Open file
     set FilePointer [open $InFilePath r]
     try {
          fconfigure $FilePointer -encoding utf-8
     
          # Read into string
          set FileData [read -nonewline $FilePointer]
     } finally {
          close $FilePointer
     }
     
     # Split on newline and return
     if {[NotEmpty $ListVarName]} {
          return [set List [split $FileData "\n"]]
     } else {
          return [split $FileData "\n"]
     }
}