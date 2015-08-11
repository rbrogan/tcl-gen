set GenNS::Ftp::Server 192.168.5.5
# This is the IP address of the remote machine you will download from / upload to.

set GenNS::Ftp::Username rbrogan
# This is the username you use to log on to that machine.

set GenNS::Ftp::Password nowcomecome
# This is the password you use to log on to that machine.

set GenNS::Ftp::OptionsList ""
# Can probably leave this as-is, unless you want to do something like change the port number.
# Check out the documentation for ftp package, ftp::Open for details.

set GenNS::Ftp::FileTransferType binary
# Can probably leave this as-is, unless you want to try another transfer type.
# The FTP package may have issues with file sizes if you use ASCII.

set FtpTestLocalRoot "./ftp-local"
# This is used to switch into the directory with the local files to use.
# Can probably leave this as-is, unless you are running tests from outside root test directory.
# By default, we assume you are running tests from the root test directory.
# If not, you will want to change it, so it can find ftp-local on your machine.

set FtpTestRemoteRoot "/home/rbrogan/ftp-remote"
# This is used to switch into the remote directory with the remote files to use.
# We left this blank so that you can change it and make sure the path is right.
# Most likely you want it to have a full path, like /home/yourusername/ftp-remote

set FtpTestDiffCommandPrefix "diff.exe -w -r"
# This is used to diff the temp directory with the expected.
# It is set up here for GNU diff on a Windows machine.
# (e.g. diff.exe -w -r ./ftp-local/downloadto/temp/one-file ./ftp-local/downloadto/expected/one-file)
