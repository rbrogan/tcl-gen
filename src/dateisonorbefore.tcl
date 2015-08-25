proc DateIsOnOrBefore {FirstDate SecondDate} {

     return [expr ![DateIsAfter $FirstDate $SecondDate]]
}