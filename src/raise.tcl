set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/ispositive.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Raise not loaded because missing packages: $::GenMissingPackages."

     proc Raise {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Raise {ListVariable SublistLength} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     if {![IsPositive $SublistLength]} {
          error [format $::ErrorMessage(INPUT_NON_POSITIVE) $SublistLength] $::errorInfo $::ErrorCode(INPUT_NON_POSITIVE)             
     }
     if {[llength $List] < $SublistLength} {
          error [format $::ErrorMessage(INPUT_OUT_OF_RANGE) $SublistLength] $::errorInfo $::ErrorCode(INPUT_OUT_OF_RANGE)
     }
     if {[expr [llength $List] % $SublistLength] != 0} {
          error [format $::ErrorMessage(CANNOT_FACTOR_INPUT_LIST) $SublistLength] $::errorInfo $::ErrorCode(CANNOT_FACTOR_INPUT_LIST)
     }
     set NewList {}
     for {set i 0} {$i < [llength $List]} {set i [expr $i + $SublistLength]} {
          set NextList {}
          for {set n 0} {$n < $SublistLength} {incr n} {
               lappend NextList [lindex $List [expr $i + $n]]			
          }
          lappend NewList $NextList
     }
     set List $NewList
}