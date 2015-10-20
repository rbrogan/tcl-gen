proc Now {} {

     return [eval "clock format [clock seconds] -format $GenNS::DatetimeFormat"]
}