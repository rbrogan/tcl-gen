proc AddPrologue {ProcName Prologue} {

     # Verify proc exists
     if {[catch {info body $ProcName} Body]} {
          error [format $::ErrorMessage(PROC_NOT_FOUND) $ProcName] $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Get proc args     
     set ProcArgs [info args $ProcName]
     # Combine body and prologue
     set NewBody "$Prologue\n$Body"
     # Delete old proc
     rename $ProcName ""
     # Create new proc with same name
     proc $ProcName $ProcArgs $NewBody
}