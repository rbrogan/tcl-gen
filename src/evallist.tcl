set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "EvalList not loaded because missing packages: $::GenMissingPackages."

     proc EvalList {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc EvalList ListValue {

	foreach Element $ListValue {
		eval $Element
	}
}