package provide gen 1.18.0

set PackageRoot [file dirname [lindex [package ifneeded gen 1.18.0]  1]]

source $PackageRoot/gen-error.tcl

source $PackageRoot/gen-config.tcl

catch {source $PackageRoot/gen-user-config.tcl}

proc GenCurrentVersion {} {
     puts 1.18.0
}

source $PackageRoot/loading-module.tcl
source $PackageRoot/loading-module-data.tcl
::GenNS::LoadingNS::DoLoading

