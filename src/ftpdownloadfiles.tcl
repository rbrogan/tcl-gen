proc FtpDownloadFiles {FileList {TargetRemoteDirectory .}} {

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

               if {$TargetRemoteDirectory ne "."} {
                    set Ok [ftp::Cd $FtpHandle $TargetRemoteDirectory]
                    if {$Ok == 0} {
                         error "FTP: Could not change into remote directory $TargetRemoteDirectory. Quitting."
                    }
               }

               foreach File $FileList {
                    DbgPrint "Downloading $File"
                    set Ok [ftp::Get $FtpHandle $File $File]
                    if {$Ok == 0} {
                         error "FTP: Could not get $File."
                    }
               }
          } finally {
               ftp::Close $FtpHandle
          }
     }

     return
}