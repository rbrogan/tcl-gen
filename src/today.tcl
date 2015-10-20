proc Today {} {

     return [eval "clock format [clock seconds] -format $GenNS::DateFormat"]
}