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