set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SqlWhereClause not loaded because missing packages: $::GenMissingPackages."

     proc SqlWhereClause {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SqlWhereClause DictValue {

     set WhereClause ""
     set Flag 0
     dict for {Key Value} $DictValue {
          if {$Flag != 0} {
               append WhereClause " AND "
          } else {
               set Flag 1
          }
          append WhereClause "$Key = $Value"
     }
     return $WhereClause
}