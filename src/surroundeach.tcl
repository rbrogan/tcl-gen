set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SurroundEach not loaded because missing packages: $::GenMissingPackages."

     proc SurroundEach {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SurroundEach {ListVariable String} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     set OutList {}
     foreach Element $List {
          lappend OutList "[set String][set Element][set String]"
     }
     set List $OutList
}