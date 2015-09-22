set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarx.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "MultiSet not loaded because missing packages: $::GenMissingPackages."

     proc MultiSet {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc MultiSet {VarNameList {ValueList ""}} {

     set OutList {}
     set NumVariables [llength $VarNameList]
     for {set i 0} {($i < [llength $ValueList]) && ($i < $NumVariables)} {incr i} {
          set VarName [lindex $VarNameList $i]
          UpvarX $VarName Var
          set Var [lindex $ValueList $i]
          lappend OutList $Var
     }

     # In case there are more variables than list elements, make the rest be empty.
     for {set i [llength $ValueList]} {$i < $NumVariables} {incr i} {
          set VarName [lindex $VarNameList $i]
          UpvarX $VarName Var
          lappend OutList $Var
     }

     return $OutList
}