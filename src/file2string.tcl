proc File2String {InFilePath {StringVarName ""}} {

     if {[NotEmpty $StringVarName]} {
          upvar $StringVarName String
     }
     
     # Open file
     set FilePointer [open $InFilePath r]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Read into string and return
          set String [read $FilePointer]
     } finally {
          close $FilePointer 
     }
     
     return $String
}