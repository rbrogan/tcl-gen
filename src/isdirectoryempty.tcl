proc IsDirectoryEmpty TargetDirectoryPath {

     return [IsEmpty [glob -nocomplain -directory $TargetDirectoryPath *]]
}