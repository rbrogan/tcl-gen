package require -exact gen 1.7.0

puts "\n\nBasic test"
catch {rename Tester ""}
proc Tester {} {incr MyVar}
AddPrologue Tester {set MyVar 2}
set Result [Tester]
if {$Result == 3} {
     puts "pass"
} else {
     error "FAIL. Expected 2, got $Result."
}

puts "\n\nNo such proc"
catch {rename NoSuchProc ""}
set Result [catch {AddPrologue NoSuchProc {set ReturnValue 123}}]
if {$Result == 1} {
     puts "pass"
} else {
     error "FAIL."
}

puts "\n\nProc has empty body"
catch {rename Tester ""}
proc Tester {} {}
AddPrologue Tester {set ReturnValue "123"}
set Result [Tester]
if {$Result == 123} {
     puts "pass"
} else {
     error "FAIL. Expected 2, got $Result."
}

puts "\n\nEpilogue is empty"
catch {rename Tester ""}
proc Tester {one two} {expr "$one + $two"}
AddPrologue Tester {}
set Result [Tester 3 4]
if {$Result == 7} {
     puts "pass"
} else {
     error "FAIL. Expected 7, got $Result."
}
