package provide gen 1.11.1

set PackageRoot [file dirname [lindex [package ifneeded gen 1.11.1]  1]]

source $PackageRoot/gen-error.tcl

source $PackageRoot/gen-config.tcl

catch {source $PackageRoot/gen-user-config.tcl}

proc GenCurrentVersion {} {
     puts 1.11.1
}

source $PackageRoot/loading-module.tcl
source $PackageRoot/loading-module-data.tcl
::GenNS::LoadingNS::DoLoading

