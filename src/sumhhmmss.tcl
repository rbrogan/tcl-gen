set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/ishhmmss.tcl

source $PackageRoot/hhmmss2seconds.tcl

source $PackageRoot/addto.tcl

source $PackageRoot/seconds2hhmmss.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SumHhmmss not loaded because missing packages: $::GenMissingPackages."

     proc SumHhmmss {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SumHhmmss ListValue {

     for {set i 0} {$i < [llength $ListValue]} {incr i} {
          set Element [lindex $ListValue $i]
          if {![IsHhmmss $Element]} {
               error [format $::ErrorMessage(LIST_HAS_INVALID_ELEMENT) ListValue $i $Element] $::errorInfo $::ErrorCode(LIST_HAS_INVALID_ELEMENT)
          }
     }

     set TotalSeconds 0
     foreach Element $ListValue {
          set ElementSeconds [Hhmmss2Seconds $Element]
          AddTo TotalSeconds $ElementSeconds
     }
     
     return [Seconds2Hhmmss $TotalSeconds]
}