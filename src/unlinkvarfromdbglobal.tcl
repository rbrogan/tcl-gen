set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "UnlinkVarFromDbGlobal not loaded because missing packages: $::GenMissingPackages."

     proc UnlinkVarFromDbGlobal {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc UnlinkVarFromDbGlobal {VarName {DbGlobalName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DbGlobalName]} {
          set DbGlobalName $VarName
     }
     uplevel "trace remove variable $VarName write \{UpdateDbGlobal $VarName $DbGlobalName\}"
}