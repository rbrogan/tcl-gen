set GenNS::Ftp::Server not-set
# This is the IP address of the remote machine you will download from / upload to.

set GenNS::Ftp::Username not-set
# This is the username you use to log on to that machine.

set GenNS::Ftp::Password not-set
# This is the password you use to log on to that machine.

set GenNS::Ftp::OptionsList ""
# Can probably leave this as-is, unless you want to do something like change the port number.
# Check out the documentation for ftp package, ftp::Open for details.

set GenNS::Ftp::FileTransferType binary
# Can probably leave this as-is, unless you want to try another transfer type.
# The FTP package may have issues with file sizes if you use ASCII.

namespace eval GenTest::Ftp {

set LocalRoot "./ftp-local"
# This is used to switch into the directory with the local files to use.
# Can probably leave this as-is, unless you are running tests from outside root test directory.
# By default, we assume you are running tests from the root test directory.
# If not, you will want to change it, so it can find ftp-local on your machine.

set RemoteRoot "not-set"
# This is used to switch into the remote directory with the remote files to use.
# We left this blank so that you can change it and make sure the path is right.
# Most likely you want it to have a full path, like /home/yourusername/ftp-remote

set DiffCommandPrefix "diff.exe -w -r"
# This is used to diff the temp directory with the expected.
# It is set up here for GNU diff on a Windows machine.
# (e.g. diff.exe -w -r ./ftp-local/downloadto/temp/one-file ./ftp-local/downloadto/expected/one-file)

set ResetRemoteDirectoryCommandName GenTest::Ftp::ResetRemoteDirectory
#"must implement yourself -- can use/adapt GenTest::Ftp::ResetRemoteDirectory"
# This is used to reset the temp directory with contents from the original.
# It takes in the name of the /original directory to copy from as its only parameter.
# You must implement this proc yourself (if you want to run upload tests), 
# but you can use the code below.
# Was tested for Windows-to-Linux.

set DiffRemoteDirectoriesCommandName GenTest::Ftp::DiffRemoteDirectories
#"must implement yourself -- can use/adapt GenTest::Ftp::DiffRemoteDirectories"
# This is used to diff the contents of the /temp directory with an /expected directory.
# It takes the name of the /expected directory to copy from as its only parameter.
# You must implement this proc yourself (if you want to run upload tests),
# but you can use the code below.
# Was tested for Windows-to-Linux.

proc ResetRemoteDirectory {RemoteDirectory} {
     ::GenTest::Ftp::RunRemote "./ftp-remote/ResetUploadtoDirectory.sh $RemoteDirectory"
}

proc DiffRemoteDirectories {RemoteDirectory} {
     variable RemoteRoot

     ::GenTest::Ftp::RunRemote "diff -w -r $RemoteRoot/uploadto/temp $RemoteRoot/uploadto/expected/$RemoteDirectory"     
}

proc RunRemote {RemoteCommand {ShowOutput 0}} {
     return ""
}

}