proc DeleteOnlyFilesInDirectory TargetDirectoryPath {

     foreach File [glob -nocomplain -directory $TargetDirectoryPath *] {
          if {[file isfile $File]} {
               file delete $File
          }
     }
}