set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/varexistsincaller.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UpvarExistingOrDie not loaded because missing packages: $::GenMissingPackages."

     proc UpvarExistingOrDie {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UpvarExistingOrDie {VarName Var} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {[IsEmpty $Var]} {
          error "Second argument is missing. Got empty string." $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }     
     if {[VarExistsInCaller $VarName 2]} {
          uplevel "upvar $VarName $Var"
     } else {
          error [format $::ErrorMessage(VARIABLE_NOT_FOUND) $VarName] $::errorInfo $::ErrorCode(VARIABLE_NOT_FOUND)
     }
     
     return
}