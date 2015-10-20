proc GuessPackageRootDirectory {PackageName PackageVersion} {

     return [file dirname [lindex [package ifneeded $PackageName $PackageVersion]  1]]
}