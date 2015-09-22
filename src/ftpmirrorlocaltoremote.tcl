set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/saveworkingdirectory.tcl

source $PackageRoot/ftpuploaddirectory.tcl

source $PackageRoot/restoreworkingdirectory.tcl

if {[catch {package require ftp}]} {
     lappend ::GenMissingPackages ftp
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FtpMirrorLocalToRemote not loaded because missing packages: $::GenMissingPackages."

     proc FtpMirrorLocalToRemote {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FtpMirrorLocalToRemote {LocalDirectory RemoteDirectory} {

     SaveWorkingDirectory
     # Open connection
     set FtpHandle [ftp::Open $GenNS::Ftp::Server $GenNS::Ftp::Username $GenNS::Ftp::Password {*}$GenNS::Ftp::OptionsList]
     if {$FtpHandle == -1} {
          DbgPrint "Could not open connection: $GenNS::Ftp::Server $GenNS::Ftp::Username $GenNS::Ftp::Password {*}$GenNS::Ftp::OptionsList"
          error "FTP: Could not open connection!"
     } else {
          try {
               # Switch to directory
               cd $LocalDirectory

               set Ok [ftp::Cd $FtpHandle $RemoteDirectory]
               if {$Ok == 0} {
                    error "FTP: Could not change into remote directory $RemoteDirectory. Quitting."
               }
               FtpUploadDirectory $FtpHandle . LocalNewerOrSizeDifferent RecurseIntoSubdirectories DeleteUnmatched
          } finally {
               ftp::Close $FtpHandle
               RestoreWorkingDirectory
          }
     }

     return
}