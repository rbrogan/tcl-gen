set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

if {[catch {package require ftp}]} {
     lappend ::GenMissingPackages ftp
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FtpIsDirectoryOnRemote not loaded because missing packages: $::GenMissingPackages."

     proc FtpIsDirectoryOnRemote {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FtpIsDirectoryOnRemote {FtpHandle TargetName} {

     set Result [ftp::FileSize $FtpHandle $TargetName]
     if {[string is integer $Result] && ($Result >= 0)} {
          return 0
     } else {
          return 1
     }
}