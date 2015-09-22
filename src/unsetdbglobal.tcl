set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/qq.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UnsetDbGlobal not loaded because missing packages: $::GenMissingPackages."

     proc UnsetDbGlobal {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UnsetDbGlobal VarName {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set ::sql "DELETE FROM $GenNS::GlobalsTable WHERE desc = '$VarName'"
     QQ $::sql
}