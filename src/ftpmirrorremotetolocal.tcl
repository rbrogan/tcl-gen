set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/notempty.tcl

source $PackageRoot/ftpdownloaddirectory.tcl

if {[catch {package require ftp}]} {
     lappend ::GenMissingPackages ftp
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FtpMirrorRemoteToLocal not loaded because missing packages: $::GenMissingPackages."

     proc FtpMirrorRemoteToLocal {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FtpMirrorRemoteToLocal {RemoteDirectory LocalDirectory} {

     set OriginalLocation [pwd]
     # Open connection
     set FtpHandle [ftp::Open $GenNS::Ftp::Server $GenNS::Ftp::Username $GenNS::Ftp::Password {*}$GenNS::Ftp::OptionsList]
     if {$FtpHandle == -1} {
          error "FTP: Could not open connection!"
     } else {
          try {
               if {[NotEmpty $GenNS::Ftp::FileTransferType]} {
                    if {[lsearch [list ascii binary tenex] $GenNS::Ftp::FileTransferType] != -1} {
                         DbgPrint "Setting file transfer type to $GenNS::Ftp::FileTransferType"
                         ftp::Type $FtpHandle $GenNS::Ftp::FileTransferType
                    } else {
                         error "Unknown FTP file transfer type $GenNS::Ftp::FileTransferType! Should be ascii, binary, tenex, or left empty."
                    }
               }

               # Switch to directory
               cd $LocalDirectory

               set Ok [ftp::Cd $FtpHandle $RemoteDirectory]
               if {$Ok == 0} {
                    error "FTP: Could not change into remote directory $RemoteDirectory. Quitting."
               }

               FtpDownloadDirectory $FtpHandle . RemoteNewerOrSizeDifferent RecurseIntoSubdirectories DeleteUnmatched
          } finally {
               DbgPrint "Closing connection"
               ftp::Close $FtpHandle
               cd $OriginalLocation
          }
     }

     return
}