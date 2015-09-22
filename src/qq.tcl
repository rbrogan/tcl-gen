set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[catch {package require sqlite3}]} {
     lappend ::GenMissingPackages sqlite3
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "QQ not loaded because missing packages: $::GenMissingPackages."

     proc QQ {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc QQ QueryStatement {

     if {[IsEmpty $QueryStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) QueryStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     return [$GenNS::DatabaseName eval $QueryStatement]
}