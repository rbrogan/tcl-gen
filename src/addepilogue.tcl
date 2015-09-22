set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "AddEpilogue not loaded because missing packages: $::GenMissingPackages."

     proc AddEpilogue {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc AddEpilogue {ProcName Epilogue} {

     # Verify proc exists
     if {[catch {info body $ProcName} Body]} {
          error [format $::ErrorMessage(PROC_NOT_FOUND) $ProcName] $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Get proc args     
     set ProcArgs [info args $ProcName]
     # Combine body and prologue
     set NewBody "$Body\n$Epilogue"
     # Delete old proc
     rename $ProcName ""
     # Create new proc with same name
     proc $ProcName $ProcArgs $NewBody
}