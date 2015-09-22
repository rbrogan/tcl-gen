set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/varexistsincaller.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/notempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UpvarX not loaded because missing packages: $::GenMissingPackages."

     proc UpvarX {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UpvarX {VarName Var {DefaultValue ""}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {[IsEmpty $Var]} {
          error "Second argument is missing. Got empty string." $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }     
     if {[VarExistsInCaller $VarName 2]} {
          uplevel 1 "upvar $VarName $Var"
     } else {
          uplevel 1 "upvar $VarName $Var"
          if {[NotEmpty $DefaultValue]} {
               uplevel 1 "set $Var $DefaultValue"
          } else {
               uplevel 1 "set $Var {}"
          }
     }
     
     return
}