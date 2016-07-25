package require tcltest
::tcltest::configure -testdir \
	[file dirname [file normalize [info script]]]
eval ::tcltest::configure $argv
eval ::tcltest::configure -skip Ftp*
::tcltest::runAllTests

