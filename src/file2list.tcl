set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/notempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "File2List not loaded because missing packages: $::GenMissingPackages."

     proc File2List {VarName Value} "error \"$::GenPackageWarning\""

     return
}


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