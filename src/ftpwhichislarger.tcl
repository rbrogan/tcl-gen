set ::GenMissingPackages {}
set ::GenPackageWarning ""

source $PackageRoot/gen-error.tcl

source $PackageRoot/isempty.tcl

if {[catch {package require ftp}]} {
     lappend ::GenMissingPackages ftp
}

if {[llength $::GenMissingPackages] > 0} {
     set ::GenPackageWarning "FtpWhichIsLarger not loaded because missing packages: $::GenMissingPackages."

     proc FtpWhichIsLarger {VarName Value} "error \"$::GenPackageWarning\""

     return
}


proc FtpWhichIsLarger {FtpHandle TargetName} {

     set LocalFileSize [file size $TargetName]
     set RemoteFileSize [ftp::FileSize $FtpHandle $TargetName]
     DbgPrint "Local file size is $LocalFileSize"
     DbgPrint "Remote file size is $RemoteFileSize"
     if {[IsEmpty $RemoteFileSize]} {
          error "FTP: Could not get remote file size for $TargetName."
     }
     if {$RemoteFileSize > $LocalFileSize} {
          return remote
     } elseif {$LocalFileSize > $RemoteFileSize} {
          return local
     } else {
          return same
     }
}