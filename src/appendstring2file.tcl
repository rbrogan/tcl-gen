set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "AppendString2File not loaded because missing packages: $::GenMissingPackages."

     proc AppendString2File {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc AppendString2File {StringValue FilePath} {

     if {[IsEmpty $FilePath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FilePath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     # Open for writing
     set FilePointer [open $FilePath a]
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