set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[catch {package require registry}]} {
     lappend ::GenMissingPackages registry
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "RegistryExists not loaded because missing packages: $::GenMissingPackages."

     proc RegistryExists {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc RegistryExists {KeyName {ValueName ""}} {

     if {[IsEmpty $KeyName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) KeyName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $ValueName]} {
          if {![catch {registry values $KeyName}]} {
               return 1
          } else {
               return 0
          }
     } else {
          if {![catch {registry get $KeyName $ValueName}]} {
               return 1
          } else {
               return 0
          }
     }
}