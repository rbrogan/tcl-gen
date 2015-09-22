set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "SliceLeft not loaded because missing packages: $::GenMissingPackages."

     proc SliceLeft {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc SliceLeft {TargetString Characters} {

     set List {}
     set Left -1
     set Right -1
     for {set i 0} {$i < [string length $TargetString]} {incr i} {
          # Check whether the current character is one of the match characters
          set Result [string first [string index $TargetString $i] $Characters]
          if {$Result >= 0} {
               # Found one
               # Because we are cutting to the left, 
               # previous character will be end of current string,
               # the found character will be start of next string
               set Right [expr $i - 1]
               if {$Right == -1} {
                    set Left $i               
                    continue
               }
               lappend List [string range $TargetString $Left $Right]
               set Left $i
          }
     }
     
     if {($Left != [string length $TargetString]) && ($Right != -1)} {
          lappend List [string range $TargetString $Left [expr [string length $TargetString] - 1]]
     } elseif {($Left == 0) && ($Right == -1)} {
          # Special case: just one character and it is target
          lappend List [string index $TargetString 0]
     } elseif {($Left == -1) && ($Right == -1)} {
          # Nothing found
          return $TargetString
     }
     
     return $List
}