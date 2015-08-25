proc DeleteEverythingInDirectory TargetDirectoryPath {

     foreach File [glob -nocomplain -directory $TargetDirectoryPath *] {
          file delete -force $File
     }
}