package require -exact gen 1.7.0

puts "\n\nBasic test"
catch {rename Tester ""}
proc Tester {} {set Total 1}
AddEpilogue Tester {incr Total}
set Result [Tester]
if {$Result == 2} {
     puts "pass"
} else {
     error "FAIL. Expected 2, got $Result."
}

puts "\n\nNo such proc"
catch {rename NoSuchProc ""}
set Result [catch {AddEpilogue NoSuchProc {set ReturnValue 123}}]
if {$Result == 1} {
     puts "pass"
} else {
     error "FAIL"
}

puts "\n\nProc has empty body"
catch {rename Tester ""}
proc Tester {} {}
AddPrologue Tester {set ReturnValue 123}
set Result [Tester]
if {$Result == 123} {
     puts "pass"
} else {
     error "FAIL. Expected 123, got $Result."
}

puts "\n\nEpilogue is empty"
catch {rename Tester ""}
proc Tester {one two} {set Total [expr "$one + $two"]}
AddPrologue Tester {}
set Result [Tester 3 4]
if {$Result == 7} {
     puts "pass"
} else {
     error "FAIL. Expected 7, got $Result."
}
