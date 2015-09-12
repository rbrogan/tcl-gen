
Gen

test/README-ftp

01| GETTING SET UP TO RUN TESTS
02| IF TESTS DO NOT PASS
03| OTHER

---01| GETTING SET UP TO RUN TESTS

The FTP tests will not work unless you do set up. To run the FTP tests, you need to do the following:

1. Set up a remote machine with an FTP server on it. This is where the code will download from and upload to.

2. Copy the contents of the ftp-remote directory to the machine with the FTP server. You can use an FTP client to do this. You may or may not have to set permissions on the directories, depending on how your machine is set up. That is another topic that you would have to research for your FTP software and/or OS, but it may be as simple as doing a chmod on the directory.

3. Open ftp-test-config.tcl and set the values for your setup (e.g. IP address, etc.). The comments in that file and doc/about-ftp-use.html should help you.

4. To get some tests to pass, the local copy must be newer than the remote. So you might want to go through ftp-local/original/different-times and touch all local-newer*.txt files.

5? The tests use a diff command to check if the results match what is expected. You may need to install diff software.

That should be it. You should now be able to run all.tcl or individual ftp*.test files and (hopefully) have them pass.

6! For some of the (uploading) tests you will have to adapt the commands used in ftp-test-config.tcl if you want to run them. Included is what we use for our Windows-to-Linux setup using plink. In the future, we may offer more support for helping you to set up your own test environment. Alternatively, you can try to manually test the commands yourself.

---02| IF TESTS DO NOT PASS

If you get failures, be aware you can do ...

set GenNS::DebugOn 1

... which is an internal feature, likely to change, but available as-is for helping with FTP issues. If you run the tests again, you will get output that may help you with figuring out the root cause of the problem.

---03| OTHER

Note that all the tests are set up to run with binary transfer type. ASCII has not been tested because have not decided how to handle the fact that results may be different depending on what kind of machines are used in the tests.

For more information about FTP use, see doc/about-ftp-use.html.
