set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/isdate.tcl

source $PackageRoot/isnonnumeric.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "DatePlusDays not loaded because missing packages: $::GenMissingPackages."

     proc DatePlusDays {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc DatePlusDays {DateVariable NumDays} {
     if {[string first @ $DateVariable] == 0} {
          UpvarExistingOrDie [string range $DateVariable 1 end] Date
     } else {
          set Date $DateVariable
     }

     if {![IsDate $Date]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DateVariable $Date] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {[IsNonNumeric $NumDays]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) NumDays $NumDays] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set DateSeconds [eval "clock scan {$Date} -format $GenNS::DateFormat"]
     set Date [eval "clock format [expr $DateSeconds + (86400*$NumDays)]  -format $GenNS::DateFormat"]
}