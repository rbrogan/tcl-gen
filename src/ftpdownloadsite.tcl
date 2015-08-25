proc FtpDownloadSite {RemoteDirectory LocalDirectory} {

     SaveWorkingDirectory
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

               ftp::Cd $FtpHandle $RemoteDirectory
               set Ok [ftp::Cd $FtpHandle $RemoteDirectory]
               if {$Ok == 0} {
                    error "Could not change into remote directory $RemoteDirectory. Quitting."
               }

               FtpDownloadDirectory $FtpHandle . OverwriteAll RecurseIntoSubdirectories LeaveUnmatched
          } finally {
               ftp::Close $FtpHandle
               RestoreWorkingDirectory
          }
     }
}