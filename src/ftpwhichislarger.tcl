proc FtpWhichIsLarger {FtpHandle TargetName} {

     set LocalFileSize [file size $TargetName]
     set RemoteFileSize [ftp::FileSize $FtpHandle $TargetName]
     DbgPrint "Local file size is $LocalFileSize"
     DbgPrint "Remote file size is $RemoteFileSize"
     if {[IsEmpty $RemoteFileSize]} {
          error "FTP: Could not get remote file size."
     }
     if {$RemoteFileSize > $LocalFileSize} {
          return remote
     } elseif {$LocalFileSize > $RemoteFileSize} {
          return local
     } else {
          return same
     }
}