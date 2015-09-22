set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "IsEmpty not loaded because missing packages: $::GenMissingPackages."

     proc IsEmpty {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc IsEmpty StringValue {

	if {[string equal $StringValue ""]} {
		return 1
	} else {
		return 0
	}
}