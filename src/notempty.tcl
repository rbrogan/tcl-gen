set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "NotEmpty not loaded because missing packages: $::GenMissingPackages."

     proc NotEmpty {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc NotEmpty StringValue {

	if {[string equal $StringValue ""] == 0} {
		return 1
	} else {
		return 0
	}
}