set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/ismatrix.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Matrix2HtmlTable not loaded because missing packages: $::GenMissingPackages."

     proc Matrix2HtmlTable {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Matrix2HtmlTable {MatrixValue {FirstRowOption --first-row-is-not-header}} {

     if {![IsMatrix $MatrixValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) MatrixValue $MatrixValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     switch $FirstRowOption {
          --first-row-is-header {
               set FirstRowIsHeader 1
          }
          --first-row-is-not-header {
               set FirstRowIsHeader 0
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstRowOption $FirstRowOption] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }

     set Flag 1

     set OutString "<table>\n"
     foreach Row $MatrixValue {
          append OutString "<tr>\n"
          foreach Cell $Row {
               if {$Flag && $FirstRowIsHeader} {
                    append OutString "<th>$Cell</th>"
               } else {
                    append OutString "<td>$Cell</td>"
               }
          }
          append OutString "\n</tr>\n"

          if {$Flag} {
               set Flag 0
          }
     }
     append OutString "</table>"
     return $OutString
}