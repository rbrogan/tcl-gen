
Gen

README

CONTENTS OF THIS FILE
---------------------
01| HOW TO USE THIS DOCUMENT
02| INTRO
03| GETTING STARTED
04| BUILDING
05| INSTALLATION
06| CONFIGURATION
07| MANUAL
08| FAQ
19| PLATFORM NOTES
10| TROUBLESHOOTING
11| KNOWN ISSUES
12| BUG REPORTING
13| FEEDBACK
14| TESTING
15| CONTRIBUTING
16| UPDATING
17| RECENT CHANGES
18| LICENSE
19| LEGAL
20| CREDITS


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
See 18|LICENSE for info about the software license. License itself is in
LICENSE.txt.
See 19|LEGAL for any additional info.

How do I get it working?
See 03|GETTING STARTED (after you have it installed and configured) to see how
to use.
See 04|BUILDING for how to compile from source (if even necessary).
See 05|INSTALLATION for how to install it on your system (and how to uninstall).
See 06|CONFIGURATION for how you can customize it for your own use.

I cannot make it work, what now?
See 10|TROUBLESHOOTING for dealing with problems with the software.
See 09|PLATFORM NOTES for ensuring it works with your platform/OS.
See 07|MANUAL to make sure you are using it correctly.
See 08|FAQ to see if your question has been answered.
See 11|KNOWN ISSUES to see if your problem is already known about (and any
workarounds / advice).
See 12|BUG REPORTING if you want to make a report and get follow-up.

What is in the other sections?
13|FEEDBACK~ - Info about things like feature requests.
14|TESTING - How you can test changes you make to the code.
15|CONTRIBUTING - How you improve the product for everyone.
16|UPDATING - How to get the latest changes.
17|RECENT CHANGES - What the latest changest are.
20|CREDITS - Who or what helped with making Gen.

---02| INTRO

Say you are in the middle of solving one problem and find you need to solve
another. Suppose you need to write the contents of a string to a file. You could
look up how to do this, but it would be nice and convenient if there were
something that does it all for you with one command.

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
1.0
% set Number 1
1
% AddTo Number 2
3

You should be all set!

---04| BUILDING

Gen is provided as a simple Tcl package and does not need to be built.

---05| INSTALLATION

If you are reading this you most likely have already successfully installed.

To install, extract the contents of the zip file. That will result in the
following files:


README.txt
     Plenty of info on how to get going.
LICENSE.txt
     Terms of use and whatnot.
WARNING.txt
     Special notices to prevent surprises.
/src
     Source files
     pkgIndex.tcl
          Used by the TCL package mechanism.
     gen.tcl
          Main script file.
/doc
     Any other documents (like the manual).
/test
     Test suite

You will probably want to add the following at the bottom of your init.tcl so
that Tcl can find the gen package:

lappend auto_path YOUR_DIR_PATH

See 06|CONFIGURATION for more info about init.tcl.

What to do after you install? You can check out the 03|GETTING STARTED section
of the README. We recommend browsing the manual (or even better, use the gen.chm
file included in your download). Each command reference has at least one
example. You can type that directly into your terminal and try out the command.

Prefer use to git and clone the repo? It is posted up for you at the following
locations: https://github.com/rbrogan/Gen
https://gitorious.org/gitorious-gen

How to uninstall? To uninstall you can simply delete the directory. You can also
remove the lappend auto_path YOUR_DIR_PATH line from your Tcl init.

---06| CONFIGURATION

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

Be sure to check this space when SQL-related commands are added.

---07| MANUAL

We have a few options. You can see the online manual at
http://www.robertbrogan.com/gen/doc/manual-home.html (which will be the most
up-to-date).

Alternatively, you can use the offline version at doc/manual-home.html or
(preferrably) use the compiled HTML Help version at doc/gen.chm.

---08| FAQ

No questions yet. We will put them here as we get them.

Please send questions you have to :

gen.questions@robertbrogan.com or you can visit
http://www.robertbrogan.com/gen/feedback.html and use the form there.

Also note, you may possibly find the answer to your question in 07|MANUAL,
09|PLATFORM NOTES, 10|TROUBLESHOOTING, or 11|KNOWN ISSUES.

---09| PLATFORM NOTES

If you have Tcl working for your platform, then the library should work without
problem.

None of the commands themselves include platform-specifc interactions (i.e. make
system calls) beyond occasionally calling another Tcl command that is
platform-specific (e.g. in an upcoming release the command Reg2Dict will call
the Tcl command registry, which is Windows-specific).

---10| TROUBLESHOOTING

No tips at this time.

Also note, you may possibly find help in 07|MANUAL, 09|PLATFORM NOTES, 08|FAQ,
or 11|KNOWN ISSUES.

---11| KNOWN ISSUES

None at this time.

None at this time. We will post them here as they arise.

---12| BUG REPORTING

Visit http://www.robertbrogan.com/gen/feedback.html.

Alternatively, send an email to one of:

gen.questions@robertbrogan.com
gen.comments@robertbrogan.com
gen.bugreport@robertbrogan.com
gen.wishlist@robertbrogan.com
gen.other@robertbrogan.com

and we will try to get back to you ASAP.

---13| FEEDBACK

You can visit our feedback page at --
http://www.robertbrogan.com/gen/feedback.html.

Alternatively, send an email to one of:

gen.questions@robertbrogan.com
gen.comments@robertbrogan.com
gen.bugreport@robertbrogan.com
gen.wishlist@robertbrogan.com
gen.other@robertbrogan.com

and we will try to get back to you ASAP.

---14| TESTING

You can find tests in the /test directory.

You will find a README file there as well, further details on things like how to
run the tests yourself.

---15| CONTRIBUTING

Nothing formal has been set up for governing this project, yet.

---16| UPDATING

The latest version can be found at
http://www.robertbrogan.com/gen/download.html.

No announcements mechanism has been set up yet. When it is, information for how
to subscribe will be put on the above page.

---17| RECENT CHANGES

Initial revision. No changes yet.

---18| LICENSE

The license is the same as the license for Tcl, for all practical purposes. See
LICENSE.txt or license.html for the actual license.

---19| LEGAL

No legal notice at this time (i.e. no use of crypto). See LICENSE.txt or
license.html for the license.

---20| CREDITS

Information posted at wiki.tcl.tk has been helpful throughout work on Tcl
projects.
