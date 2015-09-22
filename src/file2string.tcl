set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/notempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "File2String not loaded because missing packages: $::GenMissingPackages."

     proc File2String {VarName Value} "error \"$::GenPackageWarning\""

     return
}


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