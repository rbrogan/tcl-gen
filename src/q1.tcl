set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/firstof.tcl

if {[catch {package require sqlite3}]} {
     lappend ::GenMissingPackages sqlite3
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Q1 not loaded because missing packages: $::GenMissingPackages."

     proc Q1 {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Q1 QueryStatement {

     if {[IsEmpty $QueryStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) QueryStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     return [FirstOf [$GenNS::DatabaseName eval $QueryStatement]]
}