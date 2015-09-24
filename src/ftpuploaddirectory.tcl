set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/notempty.tcl

source $PackageRoot/ftpwhichisnewer.tcl

source $PackageRoot/ftpwhichislarger.tcl

source $PackageRoot/findandremove.tcl

if {[catch {package require ftp}]} {
     lappend ::GenMissingPackages ftp
}

source $PackageRoot/dbgprint.tcl

source $PackageRoot/ftpisdirectoryonremote.tcl

source $PackageRoot/ftpcleanremotedirectory.tcl

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FtpUploadDirectory not loaded because missing packages: $::GenMissingPackages."

     proc FtpUploadDirectory {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FtpUploadDirectory {FtpHandle Directory OverwritePolicy RecursePolicy DeleteUnmatchedPolicy} {

     DbgPrint "OverwritePolicy is $OverwritePolicy; RecursePolicy is $RecursePolicy, DeleteUnmatchedPolicy is $DeleteUnmatchedPolicy"

     if {($OverwritePolicy ne "OverwriteAll") && ($OverwritePolicy ne "LocalNewer") && ($OverwritePolicy ne "SizeDifferent") && ($OverwritePolicy ne "LocalNewerOrSizeDifferent") && ($OverwritePolicy ne "LocalNewerAndSizeDifferent")} {
          error "Invalid OverwritePolicy: $OverwritePolicy. Should be OverwriteAll, LocalNewer, SizeDifferent, LocalNewerOrSizeDifferent, or LocalNewerAndSizeDifferent."
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
     foreach FileName $LocalList {
          if {($FileName eq ".") || ($FileName eq "..")} {
               continue
          }
          DbgPrint "Considering $FileName ..."
          if {[file isdirectory $FileName]} {
               DbgPrint "This is a directory"
               # Check if directory exists,
               # and if not, then make it first.
               if {$RecursePolicy eq "RecurseIntoSubdirectories"} {
                    if {[lsearch $RemoteList $FileName] == -1} {
                         if {$GenNS::Ftp::DryRun == 0} {
                              DbgPrint "We do not have it yet on remote end, so making it"
                              set Ok [ftp::MkDir $FtpHandle $FileName]
                              if {$Ok == 0} {
                                   error "FTP: Could not create directory $FileName on remote. Quitting."
                              }
                         } else {
                              puts "Dry Run, will not create directory $FileName or deal with contents. Create this manually for a complete dry run. Skipping ahead."
                              continue
                         }
                    }
                    DbgPrint "Recursing into directory $FileName"
                    FtpUploadDirectory $FtpHandle $FileName $OverwritePolicy $RecursePolicy $DeleteUnmatchedPolicy
               }
               # Because this is a directory, we do not upload.
               # By this point we will have already recursed into it and uploaded.
               set DoUpload 0
          } elseif {[lsearch $RemoteList $FileName] == -1} {
               # Does not exist, do upload
               DbgPrint "Does not exist on remote. Do upload."
               set DoUpload 1
          } else {
               set Newer [FtpWhichIsNewer $FtpHandle $FileName]
               set Larger [FtpWhichIsLarger $FtpHandle $FileName]
               DbgPrint "Newer is $Newer"
               DbgPrint "Larger is $Larger"
               if {$OverwritePolicy eq "LocalNewer"} {
                    DbgPrint "OverwritePolicy is LocalNewer..."
                    if {$Newer eq "local"} {
                         DbgPrint "...and local is newer, so will do upload."
                         set DoUpload 1
                    } else {
                         DbgPrint "...and local is not newer, so will not do upload."
                         set DoUpload 0
                    }
               } elseif {$OverwritePolicy eq "SizeDifferent"} {
                    DbgPrint "OverwritePolicy is SizeDifferent..."
                    if {$Larger ne "same"} {
                         DbgPrint "...and size is not the same, so will upload."
                         set DoUpload 1
                    } else {
                         DbgPrint "...and size is the same, so will not upload."
                         set DoUpload 0
                    }
               } elseif {$OverwritePolicy eq "LocalNewerAndSizeDifferent"} {
                    DbgPrint "OverwritePolicy is LocalNewerAndSizeDifferent..."
                    if {($Newer eq "local") && ($Larger ne "same")} {
                         DbgPrint "...and local is newer and also not the same size, so will upload."
                         set DoUpload 1
                    } else {
                         DbgPrint "...and local is not newer or size is the same, so will not upload."
                         set DoUpload 0
                    }
               } elseif {$OverwritePolicy eq "LocalNewerOrSizeDifferent"} {
                    DbgPrint "OverwritePolicy is LocalNewerOrSizeDifferent..."
                    if {($Newer eq "local") || ($Larger ne "same")} {
                         DbgPrint "...and local is newer and/or not the same size, so will upload."
                         set DoUpload 1
                    } else {
                         DbgPrint "...and local is not newer and size is the same, so will not upload."
                         set DoUpload 0
                    }
               } else {
                    # $OverwritePolicy eq "OverwriteAll"
                    DbgPrint "OverwritePolicy is OverwriteAll..."
                    DbgPrint "...so will do upload."
                    set DoUpload 1
               }
          }
          
          if {$DoUpload} {
               if {$GenNS::Ftp::DryRun == 0} {
                    DbgPrint "Uploading $FileName"
                    set Ok [ftp::Put $FtpHandle $FileName $FileName]
                    if {$Ok == 0} {
                         error "FTP: Could not put $FileName"
                    }
               } else {
                    puts "Would have uploaded $FileName"
               }
          } else {
               DbgPrint "Will not upload $FileName"
          }
          FindAndRemove @RemoteList $FileName
     }
     
     if {$DeleteUnmatchedPolicy eq "DeleteUnmatched"} {
          # Delete the remaining files from the local
          foreach FileName $RemoteList {
               if {($FileName eq ".") || ($FileName eq "..")} {
                    continue
               }
               set IsDirectory [FtpIsDirectoryOnRemote $FtpHandle $FileName]
               if {$IsDirectory} {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "Deleting $FileName as directory"
                         FtpCleanRemoteDirectory $FtpHandle $FileName
                         ftp::RmDir $FtpHandle $FileName
                    } else {
                         puts "Would have deleted $FileName as directory"
                    }
               } else {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "Deleting $FileName"
                         ftp::Delete $FtpHandle $FileName
                    } else {
                         puts "Would have deleted $FileName"
                    }
               }
          }
     }
     
     cd ..
     ftp::Cd $FtpHandle ..

     return
}