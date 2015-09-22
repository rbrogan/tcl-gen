set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "List2File not loaded because missing packages: $::GenMissingPackages."

     proc List2File {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc List2File {ListValue OutFilePath} {

     # Open for writing
     set FilePointer [open $OutFilePath w+]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Write out line-by-line
          foreach Line $ListValue {
               puts $FilePointer $Line
          }
          # Clean up
          flush $FilePointer          
     } finally {
          close $FilePointer
     }
}