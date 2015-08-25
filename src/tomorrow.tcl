proc Tomorrow {} {

     return [eval "clock format [expr [clock seconds] + (3600*24)] -format $GenNS::DateFormat"]
}