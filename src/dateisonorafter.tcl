proc DateIsOnOrAfter {FirstDate SecondDate} {

     return [expr ![DateIsBefore $FirstDate $SecondDate]]
}