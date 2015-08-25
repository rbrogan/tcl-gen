proc Yesterday {} {

     set SecondsPerDay [expr 60*60*24]
     return [eval "clock format [expr [clock seconds] - $SecondsPerDay] -format $GenNS::DateFormat"]
}