set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "VarExistsInCaller not loaded because missing packages: $::GenMissingPackages."

     proc VarExistsInCaller {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc VarExistsInCaller {VarName {LevelOffset 1}} {

     set Level [expr $LevelOffset + 1]
     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     set command "info exists $VarName"
     return [uplevel $Level $command]
}