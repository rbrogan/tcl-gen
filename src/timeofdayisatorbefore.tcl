proc TimeOfDayIsAtOrBefore {FirstTimeOfDay SecondTimeOfDay} {

     return [expr ![TimeOfDayIsAfter $FirstTimeOfDay $SecondTimeOfDay]]
}