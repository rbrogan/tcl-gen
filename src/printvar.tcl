set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarexistingordie.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "PrintVar not loaded because missing packages: $::GenMissingPackages."

     proc PrintVar {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc PrintVar VarName {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarExistingOrDie $VarName Var
     puts "$VarName is $Var"
     
     return
}