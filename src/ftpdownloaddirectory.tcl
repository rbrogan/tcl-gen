proc FtpDownloadDirectory {FtpHandle Directory OverwritePolicy RecursePolicy DeleteUnmatchedPolicy} {

     DbgPrint "OverwritePolicy is $OverwritePolicy; RecursePolicy is $RecursePolicy, DeleteUnmatchedPolicy is $DeleteUnmatchedPolicy"

     if {($OverwritePolicy ne "OverwriteAll") && ($OverwritePolicy ne "RemoteNewer") && ($OverwritePolicy ne "SizeDifferent") && ($OverwritePolicy ne "RemoteNewerOrSizeDifferent") && ($OverwritePolicy ne "RemoteNewerAndSizeDifferent")} {
          error "Invalid OverwritePolicy: $OverwritePolicy. Should be OverwriteAll, RemoteNewer, SizeDifferent, RemoteNewerOrSizeDifferent, or RemoteNewerAndSizeDifferent."
     }

     if {($RecursePolicy ne "NoRecurse") && ($RecursePolicy ne "RecurseIntoSubdirectories")} {
          error "Invalid RecursePolicy: $RecursePolicy. Should be either NoRecurse or RecurseIntoSubdirectories."
     }

     if {($DeleteUnmatchedPolicy ne "DeleteUnmatched") && ($DeleteUnmatchedPolicy ne "LeaveUnmatched")} {
          error "Invalid DeleteUnmatchedPolicy: $DeleteUnmatchedPolicy. Should be either DeleteUnmatched or LeaveUnmatched."
     }

     cd $Directory
     set Ok [ftp::Cd $FtpHandle $Directory]
     if {$Ok == 0} {
          error "FTP: Could not change into remote directory $Directory. Quitting."
     }
     
     # Get list of files in remote directory
     set RemoteList [ftp::List $FtpHandle]
     if {[NotEmpty $RemoteList]} {
          set RemoteList [ftp::NList $FtpHandle]
     }
     
     # Get list of files in local directory
     set LocalList [glob -nocomplain *]
     DbgPrint "LocalList is $LocalList"
     DbgPrint "RemoteList is $RemoteList"
     foreach FileName $RemoteList {
          DbgPrint "Considering $FileName ..."
          # Check to see if it exists on local machine
          if {[FtpIsDirectoryOnRemote $FtpHandle $FileName]} {
               DbgPrint "This is a directory"
               # Check if directory exists,
               # and if not, then make it first.
               if {$RecursePolicy eq "RecurseIntoSubdirectories"} {
                    if {[lsearch $LocalList $FileName] == -1} {
                         if {$GenNS::Ftp::DryRun == 0} {
                              DbgPrint "We do not have it yet locally, so making it"
                              file mkdir $FileName
                         } else {
                              puts "Dry Run, will not create directory $FileName or deal with contents. Create this manually for a complete dry run. Skipping ahead."
                              continue
                         }
                    } else {
                         DbgPrint "Already have it"
                    }
                    DbgPrint "Recursing into directory $FileName"
                    FtpDownloadDirectory $FtpHandle $FileName $OverwritePolicy $RecursePolicy $DeleteUnmatchedPolicy
               }
               # Because this is a directory, we do not download.
               # By this point we would have already recursed into it and downloaded,
               # if necessary.
               set DoDownload 0
          } elseif {[lsearch $LocalList $FileName] == -1} {
               # Does not exist, do download
               DbgPrint "Does not exist locally. Do download."
               set DoDownload 1
          } else {
               set Newer [FtpWhichIsNewer $FtpHandle $FileName]
               set Larger [FtpWhichIsLarger $FtpHandle $FileName]
               DbgPrint "Newer is $Newer"
               DbgPrint "Larger is $Larger"
               if {$OverwritePolicy eq "RemoteNewer"} {
                    if {$Newer eq "remote"} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "SizeDifferent"} {
                    if {$Larger ne "same"} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "RemoteNewerAndSizeDifferent"} {
                    if {($Newer eq "remote") && ($Larger ne "same")} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "RemoteNewerOrSizeDifferent"} {
                    if {($Newer eq "remote") || ($Larger ne "same")} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } else {
                    # $OverwritePolicy eq "OverwriteAll"
                    set DoDownload 1
               }
          }
          
          if {$DoDownload} {
               if {$GenNS::Ftp::DryRun == 0} {
                    DbgPrint "Downloading $FileName"
                    set Ok [ftp::Get $FtpHandle $FileName $FileName]
                    if {$Ok == 0} {
                         error "FTP: Could not get $FileName."
                    }
               } else {
                    puts "Would have downloaded $FileName"
               }
          } else {
               DbgPrint "Will not download $FileName"
          }
          FindAndRemove @LocalList $FileName
     }
     
     if {$DeleteUnmatchedPolicy eq "DeleteUnmatched"} {
          # Delete the remaining files from the local
          foreach FileName $LocalList {
               set IsDirectory [file isdirectory $FileName]
               if {$IsDirectory} {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "Deleting $FileName as directory"
                         file delete -force $FileName
                    } else {
                         puts "Would have deleted $FileName as directory"
                    }
               } else {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "Deleting $FileName"
                         file delete -force $FileName
                    } else {
                         puts "Would have deleted $FileName"
                    }
               }
          }
     }
     
     cd ..
     ftp::Cd $FtpHandle ..
}