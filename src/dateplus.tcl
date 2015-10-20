proc DatePlus {DateVariable TimeAmount} {
     if {[string first @ $DateVariable] == 0} {
          UpvarExistingOrDie [string range $DateVariable 1 end] Date
     } else {
          set Date $DateVariable
     }

     if {![IsDate $Date]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DateVariable $Date] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Normalize the date format so we can scan off its elements.
     set TotalSeconds [eval "clock scan {$Date} -format \{$GenNS::DateFormat\}"]
     set Date [clock format $TotalSeconds -format {%Y-%m-%d}]

     # Scan off the elements.
     scan $Date "%04d-%02d-%02d" DateYear DateMonth DateDay
     set ScanCount [scan $TimeAmount "%dY %dM %dW %dD" YearsAdded MonthsAdded WeeksAdded DaysAdded]
     if {$ScanCount != 4} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeAmount $TimeAmount] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }

     # Do arithmetic on the year and the month separately from the rest.
     if {[expr $DateMonth + $MonthsAdded] > 12} {
          # If the months added would take us into the next year,
          # Divide by 12 to find number of years added,
          # Use modulo 12 to find out how many more months to add,
          # Add those and then if over 12, wrap around using modulo again,
          # and add one more year.
          AddTo YearsAdded [expr $MonthsAdded / 12]
          set MonthsAdded [expr $MonthsAdded % 12]
          set DateMonth [expr $DateMonth + $MonthsAdded]
          if {$DateMonth > 12} {
               set DateMonth [expr $DateMonth % 12]
               incr YearsAdded
          }
     } elseif {[expr $DateMonth + $MonthsAdded] < 1} {
          # If months added is negative,
          # and it would take us back into the previous year,
          # make number of months a positive number because Tcl does arithmetic in weird ways.
          # Find out how many more years to take away by dividing by 12.
          # Get the remaining months to take away by using modulo 12.
          # Check the month number we are on versus the number of months to take away.
          # If we have more months to take away then that means we go back into the previous year,
          # so add one more year and find the new month by starting at 12,
          # going backward by number of months, and then go forward again by month number was at.
          # (e.g. if you are in January and go back by two months then it is:
          # 12 - 2 = 10 -> +1 for January = 11 = November.
          # if you are in February and you go back by four months then it is:
          # 12 - 4 = 8 -> +2 for February = 10 = October. And so on.)
          SubtractFrom YearsAdded [expr ($MonthsAdded * -1) / 12]
          set MonthsLeft [expr ($MonthsAdded * -1) % 12]
          if {$DateMonth > $MonthsLeft} {
               set DateMonth [expr $DateMonth - $MonthsLeft]
          } else {
               SubtractFrom YearsAdded 1
               set DateMonth [expr 12 - $MonthsLeft + $DateMonth]
          }
     } else {
          # Either way we know we are not going into the next or previous year,
          # so just straight up add the months to the DateMonth.
          AddTo DateMonth $MonthsAdded
     }
     # Add to the DateYear however many years we have.
     AddTo DateYear $YearsAdded
     # Now make a new date string with our format.
     set Date [format "%04d-%02d-%02d" $DateYear $DateMonth $DateDay]
     # Convert that into seconds so we can add the days and weeks easily.
     set TotalSeconds [eval "clock scan {$Date} -format {%Y-%m-%d}"]
     # Add the number of days and weeks by converting weeks to days and adding,
     # and then converting days to seconds and adding those.
     AddTo DaysAdded [expr $WeeksAdded * 7]
     AddTo TotalSeconds [expr $DaysAdded * 24 * 60 * 60]
     # Convert the seconds back into a date string.
     set Date [eval "clock format $TotalSeconds -format \{$GenNS::DateFormat\}"]
}