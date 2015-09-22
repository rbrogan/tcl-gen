set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/ismatrix.tcl

source $PackageRoot/notempty.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/isnonnumeric.tcl

source $PackageRoot/isnonpositive.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "PrintMatrix not loaded because missing packages: $::GenMissingPackages."

     proc PrintMatrix {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc PrintMatrix {Matrix {HeaderList ""} {ColumnMaxWidthList ""}} {

     if {![IsMatrix $Matrix]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Matrix $Matrix] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set NumColumns [llength [lindex $Matrix 0]]

     if {[NotEmpty $HeaderList]} {
          if {[llength $HeaderList] != $NumColumns} {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) HeaderList $HeaderList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
          set Matrix [linsert $Matrix 0 $HeaderList]
     }

     if {[IsEmpty $ColumnMaxWidthList]} {
          set ColumnMaxWidthList [lrepeat $NumColumns max]
     } else {
          if {[llength $ColumnMaxWidthList] != $NumColumns} {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ColumnMaxWidthList $ColumnMaxWidthList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
          for {set i 0} {$i < $NumColumns} {incr i} {
               set CurrentWidth [lindex $ColumnMaxWidthList $i]
               if {($CurrentWidth ne "max") && ([IsNonNumeric $CurrentWidth] || [IsNonPositive $CurrentWidth])} {
                    error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ColumnMaxWidthList $ColumnMaxWidthList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)                    
               }
          }
     }

     for {set ColumnNumber 0} {$ColumnNumber < $NumColumns} {incr ColumnNumber} {
          if {[lindex $ColumnMaxWidthList $ColumnNumber] eq "max"} {
               set Max 0
               for {set RowNumber 0} {$RowNumber < [llength $Matrix]} {incr RowNumber} {
                    set Cell [lindex [lindex $Matrix $RowNumber] $ColumnNumber]
                    set CellWidth [string length $Cell]
                    if {$CellWidth > $Max} {
                         set Max $CellWidth
                    }
               }
               lset ColumnMaxWidthList $ColumnNumber $Max
          }
     }

     foreach Row $Matrix {
          set Count 0
          for {set i 0} {$i < $NumColumns} {incr i} {
               set Width [lindex $ColumnMaxWidthList $i]
               set String [format "%[set Width].[set Width]s" [lindex $Row $i]]
               if {$i != [expr $NumColumns - 1]} {
                    puts -nonewline "$String | "
               } else {
                    puts $String
               }
          }
     }
}