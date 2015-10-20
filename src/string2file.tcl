proc String2File {StringValue OutFilePath} {

     # Open for writing
     set FilePointer [open $OutFilePath w]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Write string to file
          puts -nonewline $FilePointer $StringValue
          # Clean up
          flush $FilePointer          
     } finally {
          close $FilePointer         
     }
}