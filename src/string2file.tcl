set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "String2File not loaded because missing packages: $::GenMissingPackages."

     proc String2File {VarName Value} "error \"$::GenPackageWarning\""

     return
}


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