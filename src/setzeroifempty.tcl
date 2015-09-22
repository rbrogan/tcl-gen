set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarx.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SetZeroIfEmpty not loaded because missing packages: $::GenMissingPackages."

     proc SetZeroIfEmpty {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SetZeroIfEmpty VarName {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     UpvarX $VarName Var
     if {[IsEmpty $Var]} {
          set Var 0
     }
     
     return $Var
}