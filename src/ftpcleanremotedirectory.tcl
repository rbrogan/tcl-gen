proc FtpCleanRemoteDirectory {FtpHandle RemoteDirectory} {

     DbgPrint "Cleaning remote directory $RemoteDirectory"
     # Switch into directory
     set Ok [ftp::Cd $FtpHandle $RemoteDirectory]
     if {$Ok == 0} {
          error "FTP: Could not change into remote directory $RemoteDirectory. Quitting."
     }
     # Get a list of contents
     set RemoteList [ftp::List $FtpHandle]
     if {[NotEmpty $RemoteList]} {
          set RemoteList [ftp::NList $FtpHandle]
     }
     DbgPrint "Got list of contents: $RemoteList"
     # Iterate over them, and
     # delete if file, recurse then delete if directory
     foreach Element $RemoteList {
          DbgPrint "Considering $Element"
          set IsDirectory [FtpIsDirectoryOnRemote $FtpHandle $Element]
          if {$IsDirectory} {
               DbgPrint "This is a directory."
               if {$GenNS::Ftp::DryRun == 0} {
                    DbgPrint "Deleting remote directory $Element"
                    FtpCleanRemoteDirectory $FtpHandle $Element
                    set Ok [ftp::RmDir $FtpHandle $Element]
                    if {$Ok == 0} {
                         error "FTP: Could not delete remote directory $Element"
                    }
               } else {
                    puts "Dry Run, would have deleted remote directory $Element"
               }
          } else {
               DbgPrint "This is a file."
               if {$GenNS::Ftp::DryRun == 0} {
                    DbgPrint "Deleting remote file $Element"
                    set Ok [ftp::Delete $FtpHandle $Element]
                    if {$Ok == 0} {
                         error "FTP: Could not delete remote file $Element"
                    }
               } else {
                    puts "Dry Run, would have deleted remote file $Element"
               }
          }
     }
     set Ok [ftp::Cd $FtpHandle ..]
     if {$Ok == 0} {
          error "FTP: Could not step back out of remote directory $RemoteDirectory. Quitting."
     }
}