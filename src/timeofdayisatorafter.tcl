proc TimeOfDayIsAtOrAfter {FirstTimeOfDay SecondTimeOfDay} {

     return [expr ![TimeOfDayIsBefore $FirstTimeOfDay $SecondTimeOfDay]]
}