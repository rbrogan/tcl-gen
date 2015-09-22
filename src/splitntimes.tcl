set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isnonnumeric.tcl

source $PackageRoot/isnonpositive.tcl

source $PackageRoot/decr.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SplitNTimes not loaded because missing packages: $::GenMissingPackages."

     proc SplitNTimes {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SplitNTimes {StringValue SplitChars Count} {

     if {[IsNonNumeric $Count] || [IsNonPositive $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set OutList {}
     set Left 0
     set Right 0
     for {set i 0} {$i < [string length $StringValue] && ($Count > 0)} {incr i} {
          for {set j 0} {$j < [string length $SplitChars] && ($Count > 0)} {incr j} {
               if {[string index $StringValue $i] eq [string index $SplitChars $j]} {
                    set Right [expr $i - 1]
                    lappend OutList [string range $StringValue $Left $Right]
                    set Left [expr $i + 1]
                    Decr Count
               }      
          }
     }

     if {$Left < [string length $StringValue]} {
          lappend OutList [string range $StringValue $Left end]
     } else {
          set LastCharacter [string index $StringValue end]
          if {[string first $SplitChars $LastCharacter] != -1} {
               lappend OutList {}
          }
     }

     return $OutList
}