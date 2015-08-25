proc CopyAllFilesIntoDirectory {SourceDirectoryPath DestinationDirectoryPath} {

     foreach File [glob -nocomplain -directory $SourceDirectoryPath *] {
          file copy -force $File $DestinationDirectoryPath
     }
}