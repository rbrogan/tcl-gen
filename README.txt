
Gen

README

CONTENTS OF THIS FILE
---------------------
01| HOW TO USE THIS DOCUMENT
02| INTRO
03| GETTING STARTED
04| DEPENDENCIES
05| BUILDING
06| INSTALLATION
07| CONFIGURATION
08| MANUAL
09| FAQ
10| PLATFORM NOTES
11| TROUBLESHOOTING
12| KNOWN ISSUES
13| BUG REPORTING
14| FEEDBACK
15| TESTING
16| CONTRIBUTING
17| UPDATING
18| RECENT CHANGES
19| LICENSE
20| LEGAL
21| CREDITS


---01| HOW TO USE THIS DOCUMENT

(Note that this README is designed to be filled out over the course of many
versions. Some sections are currently blank (e.g. Recent Changes) because it is
early in the project.)

You might prefer to use the website (http://www.robertbrogan.com/gen) for better
and more up-to-date info instead. Otherwise, prefer to use HTML versions as they
are hyperlinked.

What is the software about?
See 01|INTRO.

Is it OK for me to use? OK for me to modify? OK to make copies?
See 19|LICENSE for info about the software license. License itself is in
LICENSE.txt.
See 20|LEGAL for any additional info.

How do I get it working?
See 03|GETTING STARTED (after you have it installed and configured) to see how
to use.
See 04|DEPENDENCIES for anything external that is required or optional.
See 05|BUILDING for how to compile from source (if even necessary).
See 06|INSTALLATION for how to install it on your system (and how to uninstall).
See 07|CONFIGURATION for how you can customize it for your own use.

I cannot make it work, what now?
See 11|TROUBLESHOOTING for dealing with problems with the software.
See 10|PLATFORM NOTES for ensuring it works with your platform/OS.
See 08|MANUAL to make sure you are using it correctly.
See 09|FAQ to see if your question has been answered.
See 12|KNOWN ISSUES to see if your problem is already known about (and any
workarounds / advice).
See 13|BUG REPORTING if you want to make a report and get follow-up.

What is in the other sections?
14|FEEDBACK~ - Info about things like feature requests.
15|TESTING - How you can test changes you make to the code.
16|CONTRIBUTING - How you improve the product for everyone.
17|UPDATING - How to get the latest changes.
18|RECENT CHANGES - What the latest changest are.
21|CREDITS - Who or what helped with making Gen.

---02| INTRO

Say you are in the middle of solving one problem and find you need to solve
another. Suppose you need to insert into a string. You could write code that
will do this, but it would be nice and convenient if there were something that
does it all for you with one command.

Gen is about making it a little bit easier to write Tcl programs. Gen is
supposed to be code that you could well write yourself but do not want to have
to.

Gen is General Utilities for Tcl.

---03| GETTING STARTED

Since this is a utilities library, you do not need to do much of anything to get
started. The best thing would be to try typing in the examples from the
documentation.

If you would like to confirm the library is installed and working then try the
following from a Tcl shell.

% package require gen
1.14.0
% set Number 1
1
% AddTo Number 2
3

You should be all set!

---04| DEPENDENCIES

Gen CAN use the following packages, but they are not strictly necessary (see
below). You likely will already have got them as part of your Tcl distribution:
* sqlite3
* Tclx
* textutil::adjust
* textutil::string
* ftp
* registry (Windows only)

If you do not have these, then check the documentation that came with your
distro for information on how to get them.

However! Since the introduction of the Partial Loading feature, it is possible
to use Gen without having these packages installed. Of course, any commands that
need missing packages will not work, but you can still use any other commands
that do not need the missing packages. Inside the MANUAL you can find a page
with more details.

---05| BUILDING

Gen is provided as a simple Tcl package and does not need to be built.

---06| INSTALLATION

If you are reading this you most likely have already successfully installed.

To install, extract the contents of the archive file (.zip or .tar.gz). That
will result in the following files:


README.txt
     Plenty of info on how to get going.
LICENSE.txt
     Terms of use and whatnot.
WARNING.txt
     Special notices to prevent surprises.
/src
     Source files
     pkgIndex.tcl
          Used by the Tcl package mechanism.
     gen.tcl
          Main script file.
     gen-config.tcl
          Configuration variables (e.g. datetime format).
     gen-error.tcl
          Error codes and messages used by Gen.
     loading-module.tcl
          Code that tries to load packages and then Gen commands.
     loading-module-data.tcl
          Data used to do the loading.
     *.tcl
          Each command has its own source file.
/doc
     Any other documents (like the manual).
/test
     Test suite

You will probably want to add the following at the bottom of your init.tcl so
that Tcl can find the gen package:

lappend auto_path YOUR_DIR_PATH

See 04|DEPENDENCIES for info about what Gen may need.

See 07|CONFIGURATION for more info about init.tcl.

What to do after you install? You can check out the 03|GETTING STARTED section
of the README. We recommend browsing the manual (or even better, use the gen.chm
file included in your download). Each command reference has at least one
example. You can type that directly into your terminal and try out the command.

Prefer use to git and clone the repo? It is posted up for you at the following
locations: https://github.com/rbrogan/tcl-gen

How to uninstall? To uninstall you can simply delete the directory. You can also
remove the lappend auto_path YOUR_DIR_PATH line from your Tcl init.

---07| CONFIGURATION

You will probably want to add the following at the bottom of your init.tcl so
that Tcl can find the gen package:

lappend auto_path YOUR_DIR_PATH

How to find init.tcl? Here are some locations found for Windows and Linux. Most
likely if you use the number of your version then you can find your init.tcl in
a similar spot.

C:\Tcl\lib\tcl8.5\init.tcl
C:\Tcl\lib\tcl8.6\init.tcl
/usr/share/tcltk/tcl8.4/init.tcl
/usr/share/tcltk/tcl8.5/init.tcl

Alternatively, do a search for init.tcl starting from the root directory of your
installation.

In order to use various commands, you will want to do configuration of certain
variables. You can take a look at the following, when you need to use the
commands:

* Database
     doc/about-configuration-for-database-use.html
* Date and Time
     doc/about-date-and-time-commands.html
* FTP
     doc/about-ftp-use.html

To run the FTP tests, you will also need to do special set up. See
test/README-test-ftp.txt or test/README-test-ftp.html for details.
     
---08| MANUAL

We have a few options. You can see the online manual at
http://www.robertbrogan.com/gen/doc/manual-home.html (which will be the most
up-to-date).

Alternatively, you can use the offline version at doc/manual-home.html or
(preferrably) use the compiled HTML Help version at doc/gen.chm.

---09| FAQ

No questions yet. We will put them here as we get them.

Please send questions you have to :

gen.questions@robertbrogan.com or you can visit
http://www.robertbrogan.com/gen/feedback.html and use the form there.

Also note, you may possibly find the answer to your question in 08|MANUAL,
10|PLATFORM NOTES, 11|TROUBLESHOOTING, or 12|KNOWN ISSUES.

---10| PLATFORM NOTES

If you have Tcl working for your platform, then the library should work without
problem.

None of the commands themselves include platform-specifc interactions (i.e. make
system calls) beyond occasionally calling another Tcl command that is
platform-specific (e.g. in an upcoming release the command Reg2Dict will call
the Tcl command registry, which is Windows-specific).

---11| TROUBLESHOOTING

No tips at this time.

Also note, you may possibly find help in 07|MANUAL, 09|PLATFORM NOTES, 08|FAQ,
or 11|KNOWN ISSUES.

---12| KNOWN ISSUES

See known-issues.html or the online version at
http://www.robertbrogan.com/gen/known-issues.html.

---13| BUG REPORTING

Visit http://www.robertbrogan.com/gen/feedback.html.

Alternatively, send an email to one of:

gen.questions@robertbrogan.com
gen.comments@robertbrogan.com
gen.bugreport@robertbrogan.com
gen.wishlist@robertbrogan.com
gen.other@robertbrogan.com

and we will try to get back to you ASAP.

Note that you may also want to check known-issues.html and latest-fixes.html to
see if your issue has already been reported or perhaps already fixed.

---14| FEEDBACK

You can visit our feedback page at --
http://www.robertbrogan.com/gen/feedback.html.

Alternatively, send an email to one of:

gen.questions@robertbrogan.com
gen.comments@robertbrogan.com
gen.bugreport@robertbrogan.com
gen.wishlist@robertbrogan.com
gen.other@robertbrogan.com

and we will try to get back to you ASAP.

---15| TESTING

You can find tests in the /test directory.

You will find a README file there as well, further details on things like how to
run the tests yourself.

To run the FTP tests, you will also need to do special set up. See
test/README-test-ftp.txt or test/README-test-ftp.html for details.

---16| CONTRIBUTING

Nothing formal has been set up for governing this project, yet.

---17| UPDATING

The latest version can be found at
http://www.robertbrogan.com/gen/download.html.

Want to receive notifications about changes to Gen? You can subscribe to the
announcements mailing list by sending an email to
gen-announce-subscribe@robertbrogan.com. (No need for anything in subject or
message body.) You will get an email every time we have a new release.

Note that you may want to check out policies.html to find out how releases are
done. You may also want to check out roadmap.html to find out when the next
release is coming out.

---18| RECENT CHANGES

Version 1.14.0. You can find a change summary in news.txt / news.html and
details in changelog.txt / changelog.html.

---19| LICENSE

The license is the same as the license for Tcl, for all practical purposes. See
LICENSE.txt or license.html for the actual license.

---20| LEGAL

No legal notice at this time (i.e. no use of crypto). See LICENSE.txt or
license.html for the license.

---21| CREDITS

Information posted at wiki.tcl.tk has been helpful throughout work on Tcl
projects.

