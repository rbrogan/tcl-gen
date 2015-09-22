set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/notempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SplitAndTrim not loaded because missing packages: $::GenMissingPackages."

     proc SplitAndTrim {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SplitAndTrim {StringVariable {SplitValue " "} {TrimValue " "}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set OutList {}
     foreach Element [split $String $SplitValue] {
          set Trimmed [string trim $Element $TrimValue]
          if {[NotEmpty $Trimmed]} {
               lappend OutList $Trimmed
          }
     }
     set String $OutList
}