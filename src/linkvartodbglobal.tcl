set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/upvarx.tcl

source $PackageRoot/setdbglobal.tcl

source $PackageRoot/updatedbglobal.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "LinkVarToDbGlobal not loaded because missing packages: $::GenMissingPackages."

     proc LinkVarToDbGlobal {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc LinkVarToDbGlobal {VarName {DbGlobalName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DbGlobalName]} {
          set DbGlobalName $VarName
     }
     UpvarX $VarName Var
     uplevel "SetDbGlobal $DbGlobalName {$Var}"
     uplevel "trace add variable $VarName write \"UpdateDbGlobal $VarName $DbGlobalName\""
}