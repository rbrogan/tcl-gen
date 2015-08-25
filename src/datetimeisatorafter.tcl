proc DatetimeIsAtOrAfter {FirstDatetime SecondDatetime} {

     return [expr ![DatetimeIsBefore $FirstDatetime $SecondDatetime]]
}