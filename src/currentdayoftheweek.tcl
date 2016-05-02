proc CurrentDayOfTheWeek {{{Format %A}}} {

     return [clock format [clock seconds] -format %A]
}