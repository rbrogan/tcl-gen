proc DatetimePlus {DatetimeVariable TimeAmount} {
     if {[string first @ $DatetimeVariable] == 0} {
          UpvarExistingOrDie [string range $DatetimeVariable 1 end] Datetime
     } else {
          set Datetime $DatetimeVariable
     }

     if {![IsDatetime $Datetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DatetimeVariable $Datetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Normalize the date format so we can scan off its elements.
     set TotalSeconds [eval "clock scan {$Datetime} -format $GenNS::DatetimeFormat"]
     set Datetime [clock format $TotalSeconds -format {%Y-%m-%d %H:%M:%S}]

     # Scan off the elements.
     scan $Datetime "%04d-%02d-%02d %02d:%02d:%02d" DatetimeYear DatetimeMonth DatetimeDay DatetimeHour DatetimeMinute DatetimeSecond
     set ScanCount [scan $TimeAmount "%dY %dM %dW %dD %dH %dM %dS" YearsAdded MonthsAdded WeeksAdded DaysAdded HoursAdded MinutesAdded SecondsAdded]
     if {$ScanCount != 7} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeAmount $TimeAmount] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Do arithmetic on the year and the month separately from the rest.
     if {[expr $DatetimeMonth + $MonthsAdded] > 12} {
          # If the months added would take us into the next year,
          # Divide by 12 to find number of years added,
          # Use modulo 12 to find out how many more months to add,
          # Add those and then if over 12, wrap around using modulo again,
          # and add one more year.
          AddTo YearsAdded [expr $MonthsAdded / 12]
          set MonthsAdded [expr $MonthsAdded % 12]
          set DatetimeMonth [expr $DatetimeMonth + $MonthsAdded]
          if {$DatetimeMonth > 12} {
               set DatetimeMonth [expr $DatetimeMonth % 12]
               incr YearsAdded
          }
     } elseif {[expr $DatetimeMonth + $MonthsAdded] < 1} {
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
          if {$DatetimeMonth > $MonthsLeft} {
               set DatetimeMonth [expr $DatetimeMonth - $MonthsLeft]
          } else {
               SubtractFrom YearsAdded 1
               set DatetimeMonth [expr 12 - $MonthsLeft + $DatetimeMonth]
          }
     } else {
          # Either way we know we are not going into the next or previous year,
          # so just straight up add the months to the DateMonth.
          AddTo DatetimeMonth $MonthsAdded
     }
     AddTo DatetimeYear $YearsAdded
     # Now make a new datetime string with our format.
     set Datetime [format "%04d-%02d-%02d %02d:%02d:%02d" $DatetimeYear $DatetimeMonth $DatetimeDay $DatetimeHour $DatetimeMinute $DatetimeSecond]
     # Convert that into seconds so we can add the days and weeks with ease.
     set TotalSeconds [eval "clock scan {$Datetime} -format {%Y-%m-%d %H:%M:%S}"]
     # Convert the weeks into days and add them to the total number of days to add.
     AddTo DaysAdded [expr $WeeksAdded * 7]
     # Convert days, hours, minutes into seconds and add those to the total seconds to add.
     set SecondsFromDaysAndWeeks [expr $DaysAdded * 60 * 60 * 24]
     AddTo AddedSeconds [expr ($HoursAdded * 60 * 60) + ($MinutesAdded * 60) + $SecondsAdded + $SecondsFromDaysAndWeeks]
     # Add the seconds to get the new datetime in seconds since epoch.
     AddTo TotalSeconds $AddedSeconds
     # Convert back using [clock format]
     set Datetime [eval "clock format $TotalSeconds -format $GenNS::DatetimeFormat"]
}