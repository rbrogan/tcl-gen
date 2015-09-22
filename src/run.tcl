set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Run not loaded because missing packages: $::GenMissingPackages."

     proc Run {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Run {Script args} {

     if {[info exists ::argv]} {
          set PrevArgv $::argv
          set ResetArgv 1
     } else {
          set ResetArgv 0
     }

     set ::argv $args

     try {    
          source $Script
     } finally {
          if {$ResetArgv} {
               set ::argv $PrevArgv
          }
     }
}