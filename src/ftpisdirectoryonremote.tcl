proc FtpIsDirectoryOnRemote {FtpHandle TargetName} {

     set Result [ftp::FileSize $FtpHandle $TargetName]
     if {[string is integer $Result] && ($Result >= 0)} {
          return 0
     } else {
          return 1
     }
}