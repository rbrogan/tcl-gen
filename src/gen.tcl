package provide gen 1.10.2

set PackageRoot [file dirname [lindex [package ifneeded gen 1.10.2]  1]]

source $PackageRoot/gen-error.tcl

source $PackageRoot/gen-config.tcl

catch {source $PackageRoot/gen-user-config.tcl}

proc GenCurrentVersion {} {
     puts 1.10.2
}

source $PackageRoot/loading-module.tcl
source $PackageRoot/loading-module-data.tcl
::GenNS::LoadingNS::DoLoading

