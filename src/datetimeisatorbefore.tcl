proc DatetimeIsAtOrBefore {FirstDatetime SecondDatetime} {

     return [expr ![DatetimeIsAfter $FirstDatetime $SecondDatetime]]
}