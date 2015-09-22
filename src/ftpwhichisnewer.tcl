set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[catch {package require ftp}]} {
     lappend ::GenMissingPackages ftp
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FtpWhichIsNewer not loaded because missing packages: $::GenMissingPackages."

     proc FtpWhichIsNewer {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FtpWhichIsNewer {FtpHandle TargetName} {

     set RemoteModTime [ftp::ModTime $FtpHandle $TargetName]
     set LocalModTime [file mtime $TargetName]
     DbgPrint "Local mod time is $LocalModTime."
     DbgPrint "Remote mod time is $RemoteModTime."
     if {[IsEmpty $RemoteModTime]} {
          error "FTP: Could not get file mod time for $TargetName."
     }
     if {$RemoteModTime > $LocalModTime} {
          return remote
     } elseif {$LocalModTime > $RemoteModTime} {
          return local
     } else {
          return same
     }
}