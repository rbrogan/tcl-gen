proc RestoreWorkingDirectory {} {

     if {[NotEmpty $GenNS::SavedWorkingDirectory]} {
          cd $GenNS::SavedWorkingDirectory
     }

     return $GenNS::SavedWorkingDirectory
}