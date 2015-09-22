set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/upvarx.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "Prepend not loaded because missing packages: $::GenMissingPackages."

     proc Prepend {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc Prepend {StringVarName Value} {

     UpvarX $StringVarName String
     set String "[set Value][set String]"
     return $String
}