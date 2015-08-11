package provide gen 1.6.0
package require sqlite3
package require Tclx
package require textutil::string
package require ftp
if {[string equal $::tcl_platform(platform) "windows"]} {
     package require registry
}


array set ErrorCode {
     VARIABLE_NOT_FOUND -1
     INPUT_NON_NUMERIC -2
     VARIABLE_NAME_EMPTY -3
     INDEX_OUT_OF_RANGE -4
     INPUT_NOT_WELL_FORMED -5
     CANNOT_FACTOR_INPUT_LIST -6
     INPUT_INVALID -7
     INPUT_OUT_OF_RANGE -8
     INPUT_NON_POSITIVE -9
     SEARCH_STRING_EMPTY -10
     VARIABLE_CONTENTS_INVALID -11
     VARIABLE_CONTENTS_EMPTY -12
     DATABASE_VARIABLE_NOT_FOUND -13
     TABLE_NOT_FOUND -14
     ARGUMENTS_INCOHERENT -15
     REGISTRY_ELEMENT_NOT_FOUND -16
     PROC_NOT_FOUND -17
     ALREADY_EXISTS -18
     LIST_HAS_INVALID_ELEMENT -19
}

array set ErrorMessage {
     VARIABLE_NOT_FOUND {Could not find variable %s in caller.}
     INPUT_NON_NUMERIC {Got input value %s. Expected numeric value.}
     VARIABLE_NAME_EMPTY {Variable name is missing. Got empty string.}
     INDEX_OUT_OF_RANGE {List index %s is invalid.}
     INPUT_NOT_WELL_FORMED {Got input value %s. Expected input of the form %s.}
     CANNOT_FACTOR_INPUT_LIST {Input value %s does not divide list evenly.}
     INPUT_INVALID {Input value %s is invalid.}
     INPUT_OUT_OF_RANGE {Input value %s is out-of-range.}
     INPUT_NON_POSITIVE {Expected positive input value, got input value %s instead.}
     SEARCH_STRING_EMPTY {Got empty string for search value.}
     VARIABLE_CONTENTS_INVALID {Variable %s has invalid value %s.}
     VARIABLE_CONTENTS_EMPTY {Variable %s has empty value.}
     DATABASE_VARIABLE_NOT_FOUND {No variable called %s was found in the database globals table.}
     TABLE_NOT_FOUND {Table %s not found.}
     ARGUMENTS_INCOHERENT {Arguments %s and %s have incoherent values %s and %s.}
     REGISTRY_ELEMENT_NOT_FOUND {Registry key/value %s not found.}
     PROC_NOT_FOUND {Could not find proc %s.}
     ALREADY_EXISTS {Value %s in variable %s already exists.}
     LIST_HAS_INVALID_ELEMENT {List variable %s at index %s has invalid value %s.}
}

proc AddEpilogue {ProcName Epilogue} {

     # Verify proc exists
     if {[catch {info body $ProcName} Body]} {
          error [format $::ErrorMessage(PROC_NOT_FOUND) $ProcName] $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Get proc args     
     set ProcArgs [info args $ProcName]
     # Combine body and prologue
     set NewBody "$Body\n$Epilogue"
     # Delete old proc
     rename $ProcName ""
     # Create new proc with same name
     proc $ProcName $ProcArgs $NewBody
}

proc AddPrologue {ProcName Prologue} {

     # Verify proc exists
     if {[catch {info body $ProcName} Body]} {
          error [format $::ErrorMessage(PROC_NOT_FOUND) $ProcName] $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Get proc args     
     set ProcArgs [info args $ProcName]
     # Combine body and prologue
     set NewBody "$Prologue\n$Body"
     # Delete old proc
     rename $ProcName ""
     # Create new proc with same name
     proc $ProcName $ProcArgs $NewBody
}

proc AddTo {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     set Var [expr $Var + $Value]
}

proc AppendString2File {StringValue FilePath} {

     if {[IsEmpty $FilePath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FilePath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     # Open for writing
     set FilePointer [open $FilePath a]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Write string to file
          puts -nonewline $FilePointer $StringValue
          # Clean up
          flush $FilePointer          
     } finally {
          close $FilePointer         
     }
}

proc ArrangeDict {DictVariable Arrangement} {
     if {[string first @ $DictVariable] == 0} {
          UpvarExistingOrDie [string range $DictVariable 1 end] Dict
     } else {
          set Dict $DictVariable
     }

     set Out [dict create]
     for {set i 0} {$i < [llength $Arrangement]} {incr i} {
          set Key [lindex $Arrangement $i]
          if {[dict exists $Dict $Key]} {
               dict set Out $Key [dict get $Dict $Key]
          }
     }
     
     set Dict $Out
}

proc ChangeCasing {StringVariable From To} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set Components {}
     set FromOptions {PascalCase mixedCase {Title Case} {hyphenated-lower} {HYPHENATED-UPPER} {phrase lower} {PHRASE UPPER} {snake_lower} {SNAKE_UPPER} {none}}
     set ToOptions {PascalCase mixedCase {Title Case} {hyphenated-lower} {HYPHENATED-UPPER} {phrase lower} {PHRASE UPPER} {snake_lower} {SNAKE_UPPER} {mashedlower} {MASHEDUPPER}}     
     switch -regexp $From {
          {PascalCase} {
               set Components [lreplace [split [regsub -all {([A-Z])} $String { \1}] " "] 0 0]
          }
          {mixedCase} {
               set String [::textutil::string::cap $String]
               set Components [lreplace [split [regsub -all {([A-Z])} $String { \1}] " "] 0 0]          
          }
          {Title Case} {
               set Components [split $String " "]
          }
          {hyphenated-lower|hyphenated-case} {
               set Components [split $String "-"]
          }
          {HYPHENATED-UPPER|HYPHENATED-CASE} {
               set Components [split $String "-"]
          }
          {(phrase lower)|(phrase case)} {
               set Components [split $String " "]
          }
          {(PHRASE UPPER)|(PHRASE CASE)} {
               set Components [split $String " "]          
          }
          {snake_lower|snake_case} {
               set Components [split $String "_"]          
          }
          {SNAKE_UPPER|SNAKE_CASE} {
               set Components [split $String "_"]
          }
          {none} {
               set Components $From
          }
          default {
               error "From type $From not supported. Consider using type none." $::errorInfo $::ErrorCode(INPUT_INVALID)
          }
     }

     for {set i 0} {$i < [llength $Components]} {incr i} {
          lset Components $i [string tolower [lindex $Components $i]]
     }

     set OutString ""
     switch -regexp $To {
          {PascalCase} {
               foreach Element $Components  {
                    append OutString [::textutil::string::cap $Element]
               }
          }
          {mixedCase} {
               append OutString [lvarpop Components]
               foreach Element $Components  {
                    append OutString [::textutil::string::cap $Element]
               }          
          }
          {Title Case} {
               foreach Element $Components  {
                    append OutString "[::textutil::string::cap $Element] "
               }
               set OutString [string trimright $OutString]
          }
          {hyphenated-lower|hyphenated-case} {
               foreach Element $Components  {
                    append OutString "[set Element]-"
               }
               set OutString [string trimright $OutString -]
          }
          {HYPHENATED-UPPER|HYPHENATED-CASE} {
               foreach Element $Components  {
                    append OutString "[string toupper $Element]-"
               }          
               set OutString [string trimright $OutString -]
          }
          {mashedlower|mashedcase} {
               foreach Element $Components  {
                    append OutString [string tolower $Element]
               }          
          }
          {MASHEDUPPER|MASHEDCASE} {
               foreach Element $Components  {
                    append OutString [string toupper $Element]
               }          
          }
          {(phrase lower)|(phrase case)} {
               foreach Element $Components  {
                    append OutString "$Element "
               }          
               set OutString [string trimright $OutString]
          }
          {(PHRASE UPPER)|(PHRASE CASE)} {
               foreach Element $Components  {
                    append OutString "[string toupper $Element] "
               }          
               set OutString [string trimright $OutString]
          }
          {snake_lower|snake_case} {
               foreach Element $Components  {
                    append OutString "[set Element]_"
               }          
               set OutString [string trimright $OutString _]
          }
          {SNAKE_UPPER|SNAKE_CASE} {
               foreach Element $Components  {
                    append OutString "[string toupper $Element]_"
               }          
               set OutString [string trimright $OutString _]
          }     
          default {
               error "To type $To not supported." $::errorInfo $::ErrorCode(INPUT_INVALID)
          }
     }
     set String $OutString
}

proc ChopLeft {StringVariable {Count 1}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {![string is integer $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }

     set String [string range $String $Count end]

}

proc ChopRight {StringVariable {Count 1}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {![string is integer $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }

     set String [string range $String 0 end-$Count]
}

proc Coe args {

     set OutString ""
     foreach arg $args {
          if {[IsEmpty $arg]} {
               return ""
          } else {
               append OutString $arg
          }
     }
     return $OutString
}

proc CommaSeparatedStringToList StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set Stage1 [split $String ","]
     set Stage2 {}
     foreach Element $Stage1 {
          lappend Stage2 [string trim $Element]
     }
     set String $Stage2
}

proc CurrentTimeOfDay {} {

     return [eval "clock format [clock seconds] -format $GenNS::TimeOfDayFormat"]
}

proc DateIsAfter {FirstDate SecondDate} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set FirstSeconds [eval "clock scan {$FirstDate} -format $GenNS::DateFormat"]
     set SecondSeconds [eval "clock scan {$SecondDate} -format $GenNS::DateFormat"]
     if {$SecondSeconds < $FirstSeconds} {
          return 1
     } else {
          return 0
     }
}

proc DateIsBefore {FirstDate SecondDate} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstSeconds [eval "clock scan {$FirstDate} -format $GenNS::DateFormat"]
     set SecondSeconds [eval "clock scan {$SecondDate} -format $GenNS::DateFormat"]
     if {$SecondSeconds > $FirstSeconds} {
          return 1
     } else {
          return 0
     }
}

proc DateIsBetween {FirstDate SecondDate ThirdDate {Option BothExclusive}} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $ThirdDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdDate $ThirdDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     switch -regexp $Option {
          BothExclusive {
               set Sign1 <
               set Sign2 <
          }
          BothInclusive {
               set Sign1 <=
               set Sign2 <=
          }
          (LeftExclusive|RightInclusive) {
               set Sign1 <
               set Sign2 <=
          }
          (LeftInclusive|RightExclusive) {
               set Sign1 <=
               set Sign2 <
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Option $Option] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
          }
     }

     set FirstSeconds [eval "clock scan {$FirstDate} -format $GenNS::DateFormat"]
     set SecondSeconds [eval "clock scan {$SecondDate} -format $GenNS::DateFormat"]
     set ThirdSeconds [eval "clock scan {$ThirdDate} -format $GenNS::DateFormat"]

     if {$SecondSeconds > $ThirdSeconds} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondDate ThirdDate $SecondDate $ThirdDate] $::errorInfo $::ErrorCode(ARGUMENTS_INCOHERENT)
     }

     set Expression "($SecondSeconds $Sign1 $FirstSeconds) && ($FirstSeconds $Sign2 $ThirdSeconds)"
     if {[expr $Expression]} {
          return 1
     } else {
          return 0
     }
}

proc DateIsOn {FirstDate SecondDate} {

     if {![IsDate $FirstDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDate $FirstDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDate $SecondDate]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDate $SecondDate] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [string equal $FirstDate $SecondDate]
}

proc DateIsOnOrAfter {FirstDate SecondDate} {

     return [expr ![DateIsBefore $FirstDate $SecondDate]]
}

proc DateIsOnOrBefore {FirstDate SecondDate} {

     return [expr ![DateIsAfter $FirstDate $SecondDate]]
}

proc DateMinusDays {DateVariable NumDays} {
     if {[string first @ $DateVariable] == 0} {
          UpvarExistingOrDie [string range $DateVariable 1 end] Date
     } else {
          set Date $DateVariable
     }

     if {![IsDate $Date]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DateVariable $Date] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {[IsNonNumeric $NumDays]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) NumDays $NumDays] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set DateSeconds [eval "clock scan {$Date} -format $GenNS::DateFormat"]
     set Date [eval "clock format [expr $DateSeconds - (86400*$NumDays)]  -format $GenNS::DateFormat"]
}

proc DatePlusDays {DateVariable NumDays} {
     if {[string first @ $DateVariable] == 0} {
          UpvarExistingOrDie [string range $DateVariable 1 end] Date
     } else {
          set Date $DateVariable
     }

     if {![IsDate $Date]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DateVariable $Date] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {[IsNonNumeric $NumDays]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) NumDays $NumDays] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set DateSeconds [eval "clock scan {$Date} -format $GenNS::DateFormat"]
     set Date [eval "clock format [expr $DateSeconds + (86400*$NumDays)]  -format $GenNS::DateFormat"]
}

proc DatetimeIsAfter {FirstDatetime SecondDatetime} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set FirstSeconds [eval "clock scan {$FirstDatetime} -format $GenNS::DatetimeFormat"]
     set SecondSeconds [eval "clock scan {$SecondDatetime} -format $GenNS::DatetimeFormat"]
     if {$FirstSeconds > $SecondSeconds} {
          return 1
     } else {
          return 0
     }
}

proc DatetimeIsAt {FirstDatetime SecondDatetime} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [string equal $FirstDatetime $SecondDatetime]
}

proc DatetimeIsAtOrAfter {FirstDatetime SecondDatetime} {

     return [expr ![DatetimeIsBefore $FirstDatetime $SecondDatetime]]
}

proc DatetimeIsAtOrBefore {FirstDatetime SecondDatetime} {

     return [expr ![DatetimeIsAfter $FirstDatetime $SecondDatetime]]
}

proc DatetimeIsBefore {FirstDatetime SecondDatetime} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }


     set FirstSeconds [eval "clock scan {$FirstDatetime} -format $GenNS::DatetimeFormat"]
     set SecondSeconds [eval "clock scan {$SecondDatetime} -format $GenNS::DatetimeFormat"]
     if {$SecondSeconds > $FirstSeconds} {
          return 1
     } else {
          return 0
     }
}

proc DatetimeIsBetween {FirstDatetime SecondDatetime ThirdDatetime {Option BothExclusive}} {

     if {![IsDatetime $FirstDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstDatetime $FirstDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }
     if {![IsDatetime $SecondDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondDatetime $SecondDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }
     if {![IsDatetime $ThirdDatetime]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdDatetime $ThirdDatetime] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
     }

     switch -regexp $Option {
          BothExclusive {
               set Sign1 <
               set Sign2 <
          }
          BothInclusive {
               set Sign1 <=
               set Sign2 <=
          }
          (LeftExclusive|RightInclusive) {
               set Sign1 <
               set Sign2 <=
          }
          (LeftInclusive|RightExclusive) {
               set Sign1 <=
               set Sign2 <
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Option $Option] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)]
          }
     }

     set FirstSeconds [eval "clock scan {$FirstDatetime} -format $GenNS::DatetimeFormat"]
     set SecondSeconds [eval "clock scan {$SecondDatetime} -format $GenNS::DatetimeFormat"]
     set ThirdSeconds [eval "clock scan {$ThirdDatetime} -format $GenNS::DatetimeFormat"]
     if {$SecondSeconds > $ThirdSeconds} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondDatetime ThirdDatetime $SecondDatetime $ThirdDatetime]
     }

     set Expression "($SecondSeconds $Sign1 $FirstSeconds) && ($FirstSeconds $Sign2 $ThirdSeconds)"
     if {[expr $Expression]} {
          return 1
     } else {
          return 0
     }
}

proc DbaseRegsub {TableName ColumnName FindValue ReplaceValue {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $ColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $FindValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FindValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "SELECT id, $ColumnName FROM $TableName[set WhereClause]"
     set TotalReplacements 0
     set Results [QQ $sql]
     foreach {Id OldValue} $Results {
          set NumReplacements [regsub -all $FindValue $OldValue $ReplaceValue NewValue]
          if {$NumReplacements > 0} {
               set sql "UPDATE $TableName SET $ColumnName = '[EscapedSqlString $NewValue]' WHERE id = $Id"
               QQ $sql
               incr TotalReplacements
          }
     }
     return $TotalReplacements
}

proc DbgOff ProcName {

     set GenNS::DebugOn 0
}

proc DbgOn ProcName {

     set GenNS::DebugOn 1
}

proc DbgPrint Message {

     if {$GenNS::DebugOn} {
          puts $Message
     }
}

proc Decr {VarName {IntegerValue ""}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {![string is integer $IntegerValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) IntegerValue $IntegerValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Var]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $Var] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Var [expr $Var - [Ter {[NotEmpty $IntegerValue]} {return $IntegerValue} {return 1}]]
}

proc DecrDbGlobal {VarName {Amount 1}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Try to get the value, and if it does not exist then make it zero.
     if {[SqlRecordExists $GenNS::GlobalsTable "desc '$VarName'"]} {
          set sql "SELECT textvalue FROM $GenNS::GlobalsTable WHERE desc = \"$VarName\""               
          set CurrentValue [Q1 $sql]
     } else {
          set CurrentValue 0
     }
          
     if {[IsNonNumeric $CurrentValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $CurrentValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Amount]} {
          error [format "Amount is invalid. $::ErrorMessage(INPUT_NON_NUMERIC)" $Amount] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }

     # Decrement the value by 1 and write it back to the database
     set NewValue [expr $CurrentValue - $Amount]
     SetDbGlobal $VarName $NewValue

     # Return the now-current value.
     return $NewValue
}

proc Dict2RegistryTree {DictValue RegistryRootKey {DeleteUnmatchedOption --leave-unmatched}} {

     if {[IsEmpty $RegistryRootKey]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryRootKey] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsDict $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DictValue $DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     switch $DeleteUnmatchedOption {
          --leave-unmatched {
               set DeleteUnmatched 0
          }
          --delete-unmatched {
               set DeleteUnmatched 1
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DeleteUnmatchedOption $DeleteUnmatchedOption] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }

     registry set $RegistryRootKey

     # Iterate over the dict entries,
     # and make equivalent registry entries.
     dict for {Name Value} $DictValue {
          set FullName "$RegistryRootKey\\$Name"
          # Check if the value is itself a dict
          if {[IsDict $Value]} {
               # If so, make a subkey and recurse
               registry set $FullName
               Dict2RegistryTree $Value $FullName $DeleteUnmatchedOption
          } else {
               # If not, make a registry value.
               # If the value already exists, keep the same type.
               # If not, make it string type.
               if {[RegistryExists $RegistryRootKey $Name]} {
                    set Type [registry type $RegistryRootKey $Name]
                    registry set $RegistryRootKey $Name $Value $Type
               } else {
                    registry set $RegistryRootKey $Name $Value
               }
          }
     }
     
     # If option is set to delete unmatched elements,
     # go through and delete them.
     if {$DeleteUnmatched} {
          # If any keys/value are in the registry but not the dict,
          # delete them from the registry.
          foreach RegKey [registry keys $RegistryRootKey] {
               if {![dict exists $DictValue $RegKey]} {
                    registry delete "$RegistryRootKey\\$RegKey"
               }
          }
          
          foreach RegValueName [registry values $RegistryRootKey] {
               if {![dict exists $DictValue $RegValueName]} {
                    registry delete $RegistryRootKey $RegValueName
               }
          }
     }
}

proc DiffHhmmss {MinuendVariable Subtrahend} {
     if {[string first @ $MinuendVariable] == 0} {
          UpvarExistingOrDie [string range $MinuendVariable 1 end] Minuend
     } else {
          set Minuend $MinuendVariable
     }

     if {[IsEmpty $Minuend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) MinuendVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Subtrahend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SubtrahendVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $Minuend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) MinuendVariable $MinuendVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsHhmmss $Subtrahend]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Subtrahend $Subtrahend] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set A [Hhmmss2Seconds $Minuend]
     set B [Hhmmss2Seconds $Subtrahend]
     set Minuend [Seconds2Hhmmss [expr $A - $B]]
}

proc DivideBy {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarExistingOrDie $VarName Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     set Var [expr $Var / $Value]
     return $Var
}

proc DividesEvenly {Numerator Denominator} {

     return [expr $Numerator % $Denominator == 0]
}

proc DoubleChop {StringVariable {Count 1}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [ChopRight [ChopLeft $String $Count] $Count]

}

proc EndsWith {StringValue SearchValue} {

     if {[IsEmpty $SearchValue]} {
          error $::ErrorMessage(SEARCH_STRING_EMPTY) $::errorInfo $::ErrorCode(SEARCH_STRING_EMPTY)
     }
     set LastStart [expr [string length $StringValue] - [string length $SearchValue]]
     set EndPart [string range $StringValue $LastStart end]
     if {[string equal $EndPart $SearchValue]} {
          return 1
     } else {
          return 0
     }
}

proc EscapedSqlString StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     # Replace all single quotes in the string with double quotes and return the value.
     set String [regsub -all {'} $String {''}]
}

proc EvalList ListValue {

	foreach Element $ListValue {
		eval $Element
	}
}

proc File2List {InFilePath {ListVarName ""}} {

     if {[NotEmpty $ListVarName]} {
          upvar $ListVarName List
     }
     
     # Open file
     set FilePointer [open $InFilePath r]
     try {
          fconfigure $FilePointer -encoding utf-8
     
          # Read into string
          set FileData [read -nonewline $FilePointer]
     } finally {
          close $FilePointer
     }
     
     # Split on newline and return
     if {[NotEmpty $ListVarName]} {
          return [set List [split $FileData "\n"]]
     } else {
          return [split $FileData "\n"]
     }
}

proc File2String {InFilePath {StringVarName ""}} {

     if {[NotEmpty $StringVarName]} {
          upvar $StringVarName String
     }
     
     # Open file
     set FilePointer [open $InFilePath r]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Read into string and return
          set String [read $FilePointer]
     } finally {
          close $FilePointer 
     }
     
     return $String
}

proc FindAndRemove {ListVariable FindValue} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }


     while {[set Index [lsearch $List $FindValue]] != -1} {
          set List [lreplace $List $Index $Index]
     }
     return $List
}

proc FirstOf ListValue {

     return [lindex $ListValue 0]
}

proc Flip TargetVariable {
     if {[string first @ $TargetVariable] == 0} {
          UpvarExistingOrDie [string range $TargetVariable 1 end] Target
     } else {
          set Target $TargetVariable
     }

     if {[IsNonNumeric $Target]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Target] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     } elseif {$Target == 1} {
          set Target 0
     } elseif {$Target == 0} {
          set Target 1
     } else {
          error [format $::ErrorMessage(INPUT_OUT_OF_RANGE) $Target] $::errorInfo $::ErrorCode(INPUT_OUT_OF_RANGE)      
     }
}

proc ForeachRecord {FieldNameList SelectStatement Body} {

     if {[IsEmpty $FieldNameList]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) FieldNameList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $SelectStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SelectStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set Results [QQ $SelectStatement]
     uplevel "foreach {$FieldNameList} {$Results} {$Body}"
}

proc FtpDownloadDirectory {FtpHandle Directory OverwritePolicy RecursePolicy DeleteUnmatchedPolicy} {

     DbgPrint "OverwritePolicy is $OverwritePolicy"

     cd $Directory
     set Ok [ftp::Cd $FtpHandle $Directory]
     if {$Ok == 0} {
          error "Could not change into remote directory $Directory. Quitting."
     }
     
     # Get list of files in remote directory
     set RemoteList [ftp::List $FtpHandle]
     if {[NotEmpty $RemoteList]} {
          set RemoteList [ftp::NList $FtpHandle]
     }
     
     # Get list of files in local directory
     set LocalList [glob -nocomplain *]
     DbgPrint "LocalList is $LocalList"
     DbgPrint "RemoteList is $RemoteList"
     foreach FileName $RemoteList {
          DbgPrint "Considering $FileName ..."
          # Check to see if it exists on local machine
          if {[FtpIsDirectoryOnRemote $FtpHandle $FileName]} {
               DbgPrint "This is a directory"
               # Check if directory exists,
               # and if not, then make it first.
               if {[lsearch $LocalList $FileName] == -1} {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "We do not have it yet locally, so making it"
                         file mkdir $FileName
                    } else {
                         puts "Dry Run, will not create directory $FileName or deal with contents. Create this manually for a complete dry run. Skipping ahead."
                         continue
                    }
               } else {
                    DbgPrint "Already have it"
               }
               if {$RecursePolicy eq "RecurseIntoSubdirectories"} {
                    DbgPrint "Recursing into directory $FileName"
                    FtpDownloadDirectory $FtpHandle $FileName $OverwritePolicy $RecursePolicy $DeleteUnmatchedPolicy
               }
               # Because this is a directory, we do not download.
               # By this point we will have already recursed into it and downloaded.
               set DoDownload 0
          } elseif {[lsearch $LocalList $FileName] == -1} {
               # Does not exist, do download
               DbgPrint "Does not exist locally. Do download."
               set DoDownload 1
          } else {
               set Newer [FtpWhichIsNewer $FtpHandle $FileName]
               set Larger [FtpWhichIsLarger $FtpHandle $FileName]
               DbgPrint "Newer is $Newer"
               DbgPrint "Larger is $Larger"
               if {$OverwritePolicy eq "RemoteNewer"} {
                    if {$Newer eq "remote"} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "SizeDifferent"} {
                    if {$Larger ne "same"} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "RemoteNewerAndSizeDifferent"} {
                    if {($Newer eq "remote") && ($Larger ne "same")} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "RemoteNewerOrSizeDifferent"} {
                    if {($Newer eq "remote") || ($Larger ne "same")} {
                         set DoDownload 1
                    } else {
                         set DoDownload 0
                    }
               } elseif {$OverwritePolicy eq "OverwriteAll"} {
                    set DoDownload 1
               } else {
                    error "Invalid OverwritePolicy $OverwritePolicy. Valid options are: RemoteNewer, SizeDifferent, RemoteNewerAndSizeDifferent, RemoteNewerOrSizeDifferent, OverwriteAll"
               }
          }
          
          if {$DoDownload} {
               if {$GenNS::Ftp::DryRun == 0} {
                    DbgPrint "Downloading $FileName"
                    set Ok [ftp::Get $FtpHandle $FileName $FileName]
                    if {$Ok == 0} {
                         error "FTP error: Could not get $FileName"
                    }
               } else {
                    puts "Would have downloaded $FileName"
               }
          } else {
               DbgPrint "Will not download $FileName"
          }
          FindAndRemove @LocalList $FileName
     }
     
     if {$DeleteUnmatchedPolicy eq "DeleteUnmatched"} {
          # Delete the remaining files from the local
          foreach FileName $LocalList {
               set IsDirectory [file isdirectory $FileName]
               if {$IsDirectory} {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "Deleting $FileName as directory"
                         file delete -force $FileName
                    } else {
                         puts "Would have deleted $FileName as directory"
                    }
               } else {
                    if {$GenNS::Ftp::DryRun == 0} {
                         DbgPrint "Deleting $FileName"
                         file delete -force $FileName
                    } else {
                         puts "Would have deleted $FileName"
                    }
               }
          }
     }
     
     cd ..
     ftp::Cd $FtpHandle ..
}

proc FtpIsDirectoryOnRemote {FtpHandle TargetName} {

     set Result [ftp::FileSize $FtpHandle $TargetName]
     if {[string is integer $Result] && ($Result >= 0)} {
          return 0
     } else {
          return 1
     }
}

proc FtpMirrorRemoteToLocal {RemoteDirectory LocalDirectory} {

     set OriginalLocation [pwd]
     # Open connection
     set FtpHandle [ftp::Open $GenNS::Ftp::Server $GenNS::Ftp::Username $GenNS::Ftp::Password {*}$GenNS::Ftp::OptionsList]
     if {$FtpHandle == -1} {
          error "FTP: Could not open connection!"
     } else {
          try {
               if {[NotEmpty $GenNS::Ftp::FileTransferType]} {
                    if {[lsearch [list ascii binary tenex] $GenNS::Ftp::FileTransferType] != -1} {
                         DbgPrint "Setting file transfer type to $GenNS::Ftp::FileTransferType"
                         ftp::Type $FtpHandle $GenNS::Ftp::FileTransferType
                    } else {
                         error "Unknown FTP file transfer type $GenNS::Ftp::FileTransferType! Should be ascii, binary, tenex, or left empty."
                    }
               }

               # Switch to directory
               cd $LocalDirectory

               set Ok [ftp::Cd $FtpHandle $RemoteDirectory]
               if {$Ok == 0} {
                    error "Could not change into remote directory $RemoteDirectory. Quitting."
               }

               FtpDownloadDirectory $FtpHandle . RemoteNewerOrSizeDifferent RecurseIntoSubdirectories DeleteUnmatched
          } finally {
               DbgPrint "Closing connection"
               ftp::Close $FtpHandle
               cd $OriginalLocation
          }
     }

     return
}

proc FtpWhichIsLarger {FtpHandle TargetName} {

     set LocalFileSize [file size $TargetName]
     set RemoteFileSize [ftp::FileSize $FtpHandle $TargetName]
     DbgPrint "Local file size is $LocalFileSize"
     DbgPrint "Remote file size is $RemoteFileSize"
     if {[IsEmpty $RemoteFileSize]} {
          error "FTP: Could not get remote file size."
     }
     if {$RemoteFileSize > $LocalFileSize} {
          return remote
     } elseif {$LocalFileSize > $RemoteFileSize} {
          return local
     } else {
          return same
     }
}

proc FtpWhichIsNewer {FtpHandle TargetName} {

     set RemoteModTime [ftp::ModTime $FtpHandle $TargetName]
     set LocalModTime [file mtime $TargetName]
     DbgPrint "Local mod time is $LocalModTime."
     DbgPrint "Remote mod time is $RemoteModTime."
     if {[IsEmpty $RemoteModTime]} {
          error "FTP: Could not get file mod time for $TargetName."
     }
     if {$RemoteModTime > $LocalModTime} {
          return remote
     } elseif {$LocalModTime > $RemoteModTime} {
          return local
     } else {
          return same
     }
}

proc GetDbGlobal {VarName {Type text}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     # Determine name of column to query based on the type specified.
     switch $Type {
          text {
               set ValueType textvalue
          }
          (int|integer) {
               set ValueType intvalue
          }
          (real|float|double) {
               set ValueType realvalue
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Type $Type] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }
     # We have to verify that the record exists with an additional query,
     # in order to differentiate instance where variable exists but has null string
     # versus instance where it does not exist.
     if {[SqlRecordExists $GenNS::GlobalsTable "desc '$VarName'"]} {
          set sql "SELECT textvalue FROM $GenNS::GlobalsTable WHERE desc = \"$VarName\""               
          return [Q1 $sql]
     } else {
          error [format $::ErrorMessage(DATABASE_VARIABLE_NOT_FOUND) $VarName] $::errorInfo $::ErrorCode(DATABASE_VARIABLE_NOT_FOUND)
     }

}

proc Hhmmss2Seconds StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[IsEmpty $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) StringVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) StringVariable $String] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Flag 0
     if {[StartsWith $String "-"]} {
          set String [string range $String 1 end]
          set Flag 1
     }
     regexp {^(\d\d\d*):(\d\d)\:(\d\d)$} $String All Hours Minutes Seconds
     set String [expr $Seconds + ($Minutes * 60) + ($Hours * 60 * 60)]
     if {$Flag} {
          set String "-[set String]"
     }
     return $String
}

proc IncrDbGlobal {VarName {Amount 1}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     # Try to get the value of the variable,
     # and if it does not already exist, make it zero.
     # Try to get the value, and if it does not exist then make it zero.
     if {[SqlRecordExists $GenNS::GlobalsTable "desc '$VarName'"]} {
          set sql "SELECT textvalue FROM $GenNS::GlobalsTable WHERE desc = \"$VarName\""               
          set CurrentValue [Q1 $sql]
     } else {
          set CurrentValue 0
     }

     if {[IsNonNumeric $CurrentValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $CurrentValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Amount]} {
          error [format "Amount is invalid. $::ErrorMessage(INPUT_NON_NUMERIC)" $Amount] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }

     # Increment the value by one.
     set NewValue [expr $CurrentValue + $Amount]

     # The value back to the database.
     SetDbGlobal $VarName $NewValue

     # Return the now-current value.
     return $NewValue
}

proc IsDate StringValue {

     if {[catch {eval "clock scan {$StringValue} -format $GenNS::DateFormat"}]} {
          return 0
     } else {
          return 1
     }
}

proc IsDatetime StringValue {

     set CommandString "clock scan {$StringValue} -format $GenNS::DatetimeFormat"
     if {[catch $CommandString Temp]} {
          return 0
     } else {
          return 1
     }
}

proc IsDict StringValue {

          if {![catch {dict size $StringValue}]} {
               return 1
          } else {
               return 0
          }
}

proc IsEmpty StringValue {

	if {[string equal $StringValue ""]} {
		return 1
	} else {
		return 0
	}
}

proc IsHhmmss StringValue {

     if {[regexp {^-?(\d\d\d*):(\d\d)\:(\d\d)$} $StringValue All Hours Minutes Seconds]} {
          if {$Minutes >= 60} {
               return 0
          } elseif {$Seconds >= 60} {
               return 0
          } else {
               return 1
          }
     } else {
          return 0
     }
}

proc IsMatrix ListValue {

     set TargetLength [llength [lindex $ListValue 0]]
     foreach Element $ListValue {
          if {[llength $Element] != $TargetLength} {
               return 0
          }
     }

     return 1

}

proc IsNegative Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     if {$Value < 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNonNegative Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value >= 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNonNumeric StringValue {

     if {[IsEmpty $StringValue]} {
          return 1
     } elseif {[string is integer $StringValue]} {
          return 0
     } elseif {[string is double $StringValue]} {
          return 0
     } elseif {[string is wideinteger $StringValue]} {
          return 0
     } else {
          return 1
     }
}

proc IsNonPositive Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value <= 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNonZero Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value != 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNumeric StringValue {

     if {[IsEmpty $StringValue]} {
          return 0
     } elseif {[string is integer $StringValue]} {
          return 1
     } elseif {[string is double $StringValue]} {
          return 1
     } elseif {[string is wideinteger $StringValue]} {
          return 1
     } else {
          return 0
     }
}

proc IsPositive Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value > 0} {
          return 1
     } else {
          return 0
     }
}

proc IsTimeOfDay StringValue {

     if {[catch {eval "clock scan {$StringValue} -format $GenNS::TimeOfDayFormat"}]} {
          return 0
     } else {
          return 1
     }
}

proc IsValidListIndex {ListValue Index} {

     if {![string is integer $Index]} {
          return 0
     } elseif {[IsNegative $Index]} {
          return 0
     } elseif {[llength $ListValue] <= $Index} {
          return 0
     } else {
          return 1
     }
}

proc IsZero Value {

     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value == 0} {
          return 1
     } else {
          return 0
     }
}

proc LappendIfNotAlready {ListVarName Values} {

     UpvarX $ListVarName List
     foreach Value $Values {
          if {[lsearch $List $Value] == -1} {
               lappend List $Value
          }
     }
     return $List
}

proc LastId TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     return [Q1 "SELECT id FROM $TableName ORDER BY id DESC LIMIT 1"]
}

proc LastOf ListValue {

     set Index [expr [llength $ListValue] - 1]
     return [lindex $ListValue $Index]
}

proc LinkTclVariableToRegistryValue {VarName RegistryKeyPath RegistryValueName} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryKeyPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryKeyPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryValueName]} {
          set ValueName $VarName
     }

     UpvarX $VarName Var
     if {[RegistryExists $RegistryKeyPath $RegistryValueName]} {
          set RegistryValueType [registry type $RegistryKeyPath $RegistryValueName]
     } else {
          set RegistryValueType sz
     }

     registry set $RegistryKeyPath $RegistryValueName $Var $RegistryValueType
     uplevel 1 "trace add variable $VarName write \"UpdateRegistryValue $VarName {[ToDoubleBackslashes $RegistryKeyPath]} $RegistryValueType {$RegistryValueName}\""
}

proc LinkVarToDbGlobal {VarName {DbGlobalName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DbGlobalName]} {
          set DbGlobalName $VarName
     }
     UpvarX $VarName Var
     uplevel "SetDbGlobal $DbGlobalName {$Var}"
     uplevel "trace add variable $VarName write \"UpdateDbGlobal $VarName $DbGlobalName\""
}

proc List2File {ListValue OutFilePath} {

     # Open for writing
     set FilePointer [open $OutFilePath w+]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Write out line-by-line
          foreach Line $ListValue {
               puts $FilePointer $Line
          }
          # Clean up
          flush $FilePointer          
     } finally {
          close $FilePointer
     }
}

proc ListEndIndex ListValue {

     return [expr [llength $ListValue] - 1]
}

proc ListRemoveAt {ListVariable Index {Count 1}} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     if {[IsEmpty $List]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ListVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Index]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Index] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {$Index eq "end"} {
          set Index [expr [llength $List] - 1]
     }

     if {[IsNonNumeric $Index] || ($Index < 0) || ($Index > ([llength $List] - 1))} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Index $Index] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Count] || [IsNonPositive $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set List [lreplace $List $Index [expr $Index + $Count - 1]]
}

proc Mash StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [string tolower [join $String ""]]
}

proc Matrix2HtmlTable {MatrixValue {FirstRowOption --first-row-is-not-header}} {

     if {![IsMatrix $MatrixValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) MatrixValue $MatrixValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     switch $FirstRowOption {
          --first-row-is-header {
               set FirstRowIsHeader 1
          }
          --first-row-is-not-header {
               set FirstRowIsHeader 0
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstRowOption $FirstRowOption] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }

     set Flag 1

     set OutString "<table>\n"
     foreach Row $MatrixValue {
          append OutString "<tr>\n"
          foreach Cell $Row {
               if {$Flag && $FirstRowIsHeader} {
                    append OutString "<th>$Cell</th>"
               } else {
                    append OutString "<td>$Cell</td>"
               }
          }
          append OutString "\n</tr>\n"

          if {$Flag} {
               set Flag 0
          }
     }
     append OutString "</table>"
     return $OutString
}

proc MultiSet {VarNameList {ValueList ""}} {

     set OutList {}
     set NumVariables [llength $VarNameList]
     for {set i 0} {($i < [llength $ValueList]) && ($i < $NumVariables)} {incr i} {
          set VarName [lindex $VarNameList $i]
          UpvarX $VarName Var
          set Var [lindex $ValueList $i]
          lappend OutList $Var
     }

     # In case there are more variables than list elements, make the rest be empty.
     for {set i [llength $ValueList]} {$i < $NumVariables} {incr i} {
          set VarName [lindex $VarNameList $i]
          UpvarX $VarName Var
          lappend OutList $Var
     }

     return $OutList
}

proc MultiplyBy {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarExistingOrDie $VarName Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     set Var [expr $Var * $Value]
}

proc MultiplyHhmmss {TimeVariable Multiplier} {
     if {[string first @ $TimeVariable] == 0} {
          UpvarExistingOrDie [string range $TimeVariable 1 end] Time
     } else {
          set Time $TimeVariable
     }

     if {[IsEmpty $Time]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TimeVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Multiplier]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Multiplier] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsHhmmss $Time]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) TimeVariable $Time] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     if {[IsNonNumeric $Multiplier]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Multiplier $Multiplier] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Seconds [Hhmmss2Seconds $Time]
     set Product [tcl::mathfunc::round [expr $Seconds * $Multiplier]]
     set Time [Seconds2Hhmmss $Product]
}

proc NotEmpty StringValue {

	if {[string equal $StringValue ""] == 0} {
		return 1
	} else {
		return 0
	}
}

proc Now {} {

     return [eval "clock format [clock seconds] -format $GenNS::DatetimeFormat"]
}

proc Prepend {StringVarName Value} {

     UpvarX $StringVarName String
     set String "[set Value][set String]"
     return $String
}

proc PrintDict {DictValue {IndentationSpaces 0}} {

     if {![IsDict $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DictValue $DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     # Create string full of spaces to indent
     set Spaces [string repeat " " $IndentationSpaces]

     # Make first pass to figure out the length of the greatest key
     set MaxKeyLength 0
     dict for {Key Value} $DictValue {
          set CurrentKeyLength [string length $Key]
          set MaxKeyLength [Ter {$CurrentKeyLength > $MaxKeyLength} {return $CurrentKeyLength} {return $MaxKeyLength}]
     }

     # Make another pass to print each key and value.
     dict for {Key Value} $DictValue {
          if {[IsDict $Value]} {
               # This is a dict so, print the key and recurse.
               puts [format "$Spaces%[set MaxKeyLength]s" $Key]
               # Add to the length the space needed for the largest key plus one.
               PrintDict $Value [expr $MaxKeyLength + $IndentationSpaces + 1]
          } else {
               # Otherwise, just print key and value on one line.
               puts [format "$Spaces%[set MaxKeyLength]s $Value" $Key]
          }
     }
}

proc PrintMatrix {Matrix {HeaderList ""} {ColumnMaxWidthList ""}} {

     if {![IsMatrix $Matrix]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Matrix $Matrix] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set NumColumns [llength [lindex $Matrix 0]]

     if {[NotEmpty $HeaderList]} {
          if {[llength $HeaderList] != $NumColumns} {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) HeaderList $HeaderList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
          set Matrix [linsert $Matrix 0 $HeaderList]
     }

     if {[IsEmpty $ColumnMaxWidthList]} {
          set ColumnMaxWidthList [lrepeat $NumColumns max]
     } else {
          if {[llength $ColumnMaxWidthList] != $NumColumns} {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ColumnMaxWidthList $ColumnMaxWidthList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
          for {set i 0} {$i < $NumColumns} {incr i} {
               set CurrentWidth [lindex $ColumnMaxWidthList $i]
               if {($CurrentWidth ne "max") && ([IsNonNumeric $CurrentWidth] || [IsNonPositive $CurrentWidth])} {
                    error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ColumnMaxWidthList $ColumnMaxWidthList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)                    
               }
          }
     }

     for {set ColumnNumber 0} {$ColumnNumber < $NumColumns} {incr ColumnNumber} {
          if {[lindex $ColumnMaxWidthList $ColumnNumber] eq "max"} {
               set Max 0
               for {set RowNumber 0} {$RowNumber < [llength $Matrix]} {incr RowNumber} {
                    set Cell [lindex [lindex $Matrix $RowNumber] $ColumnNumber]
                    set CellWidth [string length $Cell]
                    if {$CellWidth > $Max} {
                         set Max $CellWidth
                    }
               }
               lset ColumnMaxWidthList $ColumnNumber $Max
          }
     }

     foreach Row $Matrix {
          set Count 0
          for {set i 0} {$i < $NumColumns} {incr i} {
               set Width [lindex $ColumnMaxWidthList $i]
               set String [format "%[set Width].[set Width]s" [lindex $Row $i]]
               if {$i != [expr $NumColumns - 1]} {
                    puts -nonewline "$String | "
               } else {
                    puts $String
               }
          }
     }
}

proc PrintVar VarName {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarExistingOrDie $VarName Var
     puts "$VarName is $Var"
     
     return
}

proc Q1 QueryStatement {

     if {[IsEmpty $QueryStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) QueryStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     return [FirstOf [$GenNS::DatabaseName eval $QueryStatement]]
}

proc QQ QueryStatement {

     if {[IsEmpty $QueryStatement]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) QueryStatement] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     return [$GenNS::DatabaseName eval $QueryStatement]
}

proc QuoteIfColumnTypeIsText {TableName ColumnName TargetVariable} {
     if {[string first @ $TargetVariable] == 0} {
          UpvarExistingOrDie [string range $TargetVariable 1 end] Target
     } else {
          set Target $TargetVariable
     }

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $ColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $Target]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) Target] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     # Find the type of the target column.
     # If it is text then escape and single quote the string, and return that.
     # Otherwise, return back the same input, unchanged.
     set ColumnType [SqliteColumnType $TableName $ColumnName]
     if {$ColumnType eq "text"} {
          set Target "'[EscapedSqlString $Target]'"
     }

     return $Target
}

proc Raise {ListVariable SublistLength} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     if {![IsPositive $SublistLength]} {
          error [format $::ErrorMessage(INPUT_NON_POSITIVE) $SublistLength] $::errorInfo $::ErrorCode(INPUT_NON_POSITIVE)             
     }
     if {[llength $List] < $SublistLength} {
          error [format $::ErrorMessage(INPUT_OUT_OF_RANGE) $SublistLength] $::errorInfo $::ErrorCode(INPUT_OUT_OF_RANGE)
     }
     if {[expr [llength $List] % $SublistLength] != 0} {
          error [format $::ErrorMessage(CANNOT_FACTOR_INPUT_LIST) $SublistLength] $::errorInfo $::ErrorCode(CANNOT_FACTOR_INPUT_LIST)
     }
     set NewList {}
     for {set i 0} {$i < [llength $List]} {set i [expr $i + $SublistLength]} {
          set NextList {}
          for {set n 0} {$n < $SublistLength} {incr n} {
               lappend NextList [lindex $List [expr $i + $n]]			
          }
          lappend NewList $NextList
     }
     set List $NewList
}

proc RegistryExists {KeyName {ValueName ""}} {

     if {[IsEmpty $KeyName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) KeyName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $ValueName]} {
          if {![catch {registry values $KeyName}]} {
               return 1
          } else {
               return 0
          }
     } else {
          if {![catch {registry get $KeyName $ValueName}]} {
               return 1
          } else {
               return 0
          }
     }
}

proc RegistryPrint RegistryKeyPath {

     if {![RegistryExists $RegistryKeyPath]} {
          error [format $::ErrorMessage(REGISTRY_ELEMENT_NOT_FOUND) $RegistryKeyPath] $::errorInfo $::ErrorCode(REGISTRY_ELEMENT_NOT_FOUND)
     }

     set Dict [RegistryTree2Dict $RegistryKeyPath]
     PrintDict $Dict

}

proc RegistryTree2Dict {CurrentRegKey {CurrentDictName ""}} {

     if {[IsEmpty $CurrentRegKey]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) CurrentRegKey] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![RegistryExists $CurrentRegKey]} {
          error [format $::ErrorMessage(REGISTRY_ELEMENT_NOT_FOUND) $CurrentRegKey] $::errorInfo $::ErrorCode(REGISTRY_ELEMENT_NOT_FOUND)
     }

     set CurrentDict [dict create]

     # Go through each value in the current registry key.
     foreach RegValueName [registry values $CurrentRegKey] {
          # Get the data from the registry for the current value.
          set RegValueData [registry get $CurrentRegKey $RegValueName]
          # Add an entry to the current dict with the name and data of the value.
          dict set CurrentDict $RegValueName $RegValueData
     }

     # Go through each subkey under the current registry key.
     foreach RegKey [registry keys $CurrentRegKey] {
          # Recurse and get a dict.
          set DictValue [RegistryTree2Dict "$CurrentRegKey\\$RegKey"]
          # Add an entry to the current dict the with name of the subkey,
          # and the dict as the value
          dict set CurrentDict $RegKey $DictValue
     }
   
   
     return $CurrentDict
}

proc ReloadPackage {Name {Version ""}} {

     if {[IsEmpty $Version]} {
          package forget $Name
          package require $Name
     } else {
          package forget $Name
          package require -exact $Name $Version
     }
}

proc RestoreWorkingDirectory {} {

     if {[NotEmpty $GenNS::SavedWorkingDirectory]} {
          cd $GenNS::SavedWorkingDirectory
     }

     return $GenNS::SavedWorkingDirectory
}

proc RetZeroIfEmpty Value {

     if {[IsEmpty $Value]} {
          return 0
     } else {
          return $Value
     }
}

proc Run {Script args} {

     global argv

     set argv $args
    
     source $Script
}

proc RunSqlCreateTable {TableName ColumnNameTypeList} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $ColumnNameTypeList]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnNameTypeList] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     # From the name-type list, make a string of the form:
     # name1 type1, name2 type2, ...
     set Flag 0
     set StringList ""
     foreach {Name Type} $ColumnNameTypeList {
          if {$Flag == 0} {
               set Flag 1
          } else {
               append StringList ", "
          }
          append StringList "$Name $Type"
     }
     # Construct a CREATE TABLE statement and execute it.
     set sql "CREATE TABLE $TableName ($StringList)"
     QQ $sql

     return
}

proc RunSqlEnter {TableName WhereDict {SetDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $WhereDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # If we have just a WhereDict then this reduces to an insert if does not exist.
     if {[IsEmpty $SetDict]} {
          return [RunSqlInsertIfDoesNotExist $TableName $WhereDict]
     }
     # Otherwise we have to do the equivalent except that even when it does exist,
     # we still do an update using the SetDict.
     # Construct SELECT and determine if an entry exists
     set sql "SELECT id FROM $TableName WHERE [SqlWhereClause $WhereDict]"
     set Id [Q1 $sql]
     if {[NotEmpty $Id]} {
          # If so, construct an update
          set sql [SqlUpdateStatement $TableName $SetDict $WhereDict]
          QQ $sql
     } else {
          # If not, construct an insert
          set sql [SqlInsertStatement $TableName [dict merge $WhereDict $SetDict]]
          QQ $sql
          set Id [LastId $TableName]
     }
     
     return $Id
}

proc RunSqlInsertIfDoesNotExist {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Get the ID of the record if it does exist.
     set sql [SqlSelectStatement $TableName id $DictValue]
     set Id [Q1 $sql]
     if {[IsEmpty $Id]} {
          # If no record was found then do an insert and get the ID.
          set sql "INSERT INTO $TableName ([join [dict keys $DictValue] ","]) VALUES ([join [dict values $DictValue] ","])"
          QQ $sql
          set Id [LastId $TableName]
     }
     return $Id
}

proc SaveWorkingDirectory {} {

     set GenNS::SavedWorkingDirectory [pwd]
}

proc Seconds2Hhmmss StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[IsEmpty $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) StringVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsNonNumeric $String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) StringVariable $String] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Flag 0
     if {[expr $String < 0]} {
          set Flag 1
          set Seconds [expr $String * -1]
     } else {
          set Seconds $String
     }

     set Hours [expr $Seconds / 3600]
     set Temp [expr $Seconds % 3600]
     set Minutes [expr $Temp / 60]
     set Seconds [expr $Temp % 60]
     
     set Output [format "%02d:%02d:%02d" $Hours $Minutes $Seconds]
     if {$Flag} {
          set Output "-[set Output]"
     }
     return $Output
}

proc SetDateFormat FormatString {

     if {[catch {eval "clock format 0 -format $FormatString"} Result]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     } elseif {[string equal $Result $FormatString]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set GenNS::DateFormat $FormatString
}

proc SetDatetimeFormat FormatString {

     if {[catch {eval "clock format 0 -format \{$FormatString\}"} Result]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     } elseif {[string equal $Result $FormatString]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set GenNS::DatetimeFormat $FormatString
}

proc SetDbGlobal {VarName {Value "DoGetDbGlobal"}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {$Value eq "DoGetDbGlobal"} {
          return [GetDbGlobal $VarName]
     } elseif {[IsEmpty $Value]} {
          # Enter an empty string as empty text value with nulls for intvalue and realvalue.
          RunSqlEnter $GenNS::GlobalsTable [dict create desc "'$VarName'"] [dict create textvalue "''" intvalue null realvalue null]
     } elseif {[string is double $Value]} {
          # If it is a double then for the intvalue, enter a truncated value.
          RunSqlEnter $GenNS::GlobalsTable [dict create desc '$VarName'] [dict create realvalue $Value intvalue [::tcl::mathfunc::floor $Value] textvalue '$Value']
     } elseif {[string is integer $Value]} {
          # If it is an integer then for the realvalue add ".0"
          RunSqlEnter $GenNS::GlobalsTable [dict create "desc '$VarName'"] [dict create intvalue $Value realvalue [set Value].0 textvalue "'$Value'"]
     } else {
          # Any other string enter as text with the intvalue and realvalue as null.
          RunSqlEnter $GenNS::GlobalsTable [dict create desc '$VarName'] [dict create textvalue "'$Value'" intvalue null realvalue null]
     }

     return $Value
}

proc SetTimeOfDayFormat FormatString {

     if {[catch {eval "clock format 0 -format $FormatString"} Result]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     } elseif {[string equal $Result $FormatString]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FormatString $FormatString] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set GenNS::TimeOfDayFormat $FormatString
}

proc SetZeroIfEmpty VarName {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     UpvarX $VarName Var
     if {[IsEmpty $Var]} {
          set Var 0
     }
     
     return $Var
}

proc SliceLeft {TargetString Characters} {

     set List {}
     set Left -1
     set Right -1
     for {set i 0} {$i < [string length $TargetString]} {incr i} {
          # Check whether the current character is one of the match characters
          set Result [string first [string index $TargetString $i] $Characters]
          if {$Result >= 0} {
               # Found one
               # Because we are cutting to the left, 
               # previous character will be end of current string,
               # the found character will be start of next string
               set Right [expr $i - 1]
               if {$Right == -1} {
                    set Left $i               
                    continue
               }
               lappend List [string range $TargetString $Left $Right]
               set Left $i
          }
     }
     
     if {($Left != [string length $TargetString]) && ($Right != -1)} {
          lappend List [string range $TargetString $Left [expr [string length $TargetString] - 1]]
     } elseif {($Left == 0) && ($Right == -1)} {
          # Special case: just one character and it is target
          lappend List [string index $TargetString 0]
     } elseif {($Left == -1) && ($Right == -1)} {
          # Nothing found
          return $TargetString
     }
     
     return $List
}

proc SliceRight {TargetString Characters} {

     set List {}
     set Left -1
     set Right -1
     for {set i 0} {$i < [string length $TargetString]} {incr i} {
          # Check whether the current character is one of the match characters
          set Result [string first [string index $TargetString $i] $Characters]
          if {$Result >= 0} {
               # Found one
               # Because we are cutting to the right, 
               # the found character will be end of current string
               # next character will be start of next string,

               set Right $i
               if {$Right == -1} {
                    # Hit it on first index
                    lappend List [string range $TargetString 0 0]
                    set Left 1
               } else {
                    lappend List [string range $TargetString $Left $Right]
                    set Left [expr $i + 1]
               }
          }
     }
          
     if {($Left == -1) && ($Right == -1)} {
          # Nothing found
          return $TargetString     
     } elseif {($Right != [expr [string length $TargetString] - 1])} {
          lappend List [string range $TargetString $Left [expr [string length $TargetString] - 1]]
     } 
     
     return $List
}

proc SplitAndTrim {StringVariable {SplitValue " "} {TrimValue " "}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set OutList {}
     foreach Element [split $String $SplitValue] {
          set Trimmed [string trim $Element $TrimValue]
          if {[NotEmpty $Trimmed]} {
               lappend OutList $Trimmed
          }
     }
     set String $OutList
}

proc SplitNTimes {StringValue SplitChars Count} {

     if {[IsNonNumeric $Count] || [IsNonPositive $Count]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Count $Count] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set OutList {}
     set Left 0
     set Right 0
     for {set i 0} {$i < [string length $StringValue] && ($Count > 0)} {incr i} {
          for {set j 0} {$j < [string length $SplitChars] && ($Count > 0)} {incr j} {
               if {[string index $StringValue $i] eq [string index $SplitChars $j]} {
                    set Right [expr $i - 1]
                    lappend OutList [string range $StringValue $Left $Right]
                    set Left [expr $i + 1]
                    Decr Count
               }      
          }
     }

     if {$Left < [string length $StringValue]} {
          lappend OutList [string range $StringValue $Left end]
     } else {
          set LastCharacter [string index $StringValue end]
          if {[string first $SplitChars $LastCharacter] != -1} {
               lappend OutList {}
          }
     }

     return $OutList
}

proc SqlCountStatement {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set WhereClause [Coe " WHERE " [SqlWhereClause $DictValue]]
     return "SELECT count(1) FROM $TableName$WhereClause"
}

proc SqlInsertStatement {TableName DictValue} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set KeyList {}
     set ValueList {}
     dict for {Key Value} $DictValue {
          lappend KeyList $Key
          lappend ValueList $Value
     }
     set sql "INSERT INTO $TableName ([join $KeyList ", "]) VALUES ([join $ValueList ", "])"
     return $sql
}

proc SqlRecordExists {TableName WhereDict} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $WhereDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set CountQuery [SqlCountStatement $TableName $WhereDict]
     set Count [Q1 $CountQuery]
     if {$Count > 0} {
          return 1
     } else {
          return 0
     }
}

proc SqlSelectStatement {TableName {TargetList *} {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $TargetList]} {
          set TargetList *
     }
     set TargetClause [join $TargetList ", "]
     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "SELECT $TargetClause FROM $TableName$WhereClause"
     return $sql
}

proc SqlSetClause DictValue {

     if {[IsEmpty $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set SetClause ""
     set Flag 0
     dict for {Key Value} $DictValue {
          if {$Flag != 0} {
               append SetClause ", "
          } else {
               set Flag 1
          }
          append SetClause "$Key = $Value"
     }
     
     return $SetClause
}

proc SqlUpdateStatement {TableName SetDict {WhereDict ""}} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $SetDict]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SetDict] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set WhereClause [Coe " WHERE " [SqlWhereClause $WhereDict]]
     set sql "UPDATE $TableName SET [SqlSetClause $SetDict]$WhereClause"
     return $sql
}

proc SqlWhereClause DictValue {

     set WhereClause ""
     set Flag 0
     dict for {Key Value} $DictValue {
          if {$Flag != 0} {
               append WhereClause " AND "
          } else {
               set Flag 1
          }
          append WhereClause "$Key = $Value"
     }
     return $WhereClause
}

proc SqliteColumnNameAndTypeList TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Get the CREATE TABLE statement used (or throw error if cannot find)
     set sql "SELECT sql FROM sqlite_master WHERE tbl_name = '$TableName'"
     set Result [Q1 $sql]
     if {[IsEmpty $Result]} {
          error [format $::ErrorMessage(TABLE_NOT_FOUND) $TableName] $::errorInfo $::ErrorCode(TABLE_NOT_FOUND)          
     }
     # Extract from the statement a list of name-type values for columns.
     regexp {CREATE TABLE \w+\s?\((.+)\)} $Result All Fields
     set FieldList [split $Fields ","]
     # Construct a where each element is a name or type, suitable for use as a dict.
     set NameTypePairList {}
     foreach Element $FieldList {
          set Name [lvarpop Element]
          lappend NameTypePairList $Name $Element
     }
     return $NameTypePairList
}

proc SqliteColumnNameList TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Get the CREATE TABLE statement used (or throw error if cannot find)
     set sql "SELECT sql FROM sqlite_master WHERE tbl_name = '$TableName'"
     set Result [Q1 $sql]
     if {[IsEmpty $Result]} {
          error [format $::ErrorMessage(TABLE_NOT_FOUND) $TableName] $::errorInfo $::ErrorCode(TABLE_NOT_FOUND)    
     }
     # Extract from the statement a list of name-type values for columns.
     regexp {CREATE TABLE \w+ \((.+)\)} $Result All One
     set Two [split $One ","]
     # Construct a list with just the column names.
     set Three {}
     foreach Element $Two { 
          lappend Three [lindex $Element 0] 
     }
     return $Three
}

proc SqliteColumnType {TableName ColumnName} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $ColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) ColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set List [SqliteColumnNameAndTypeList $TableName]
     return [dict get $List $ColumnName]
}

proc SqliteCopyTable {SourceTableName TargetTableName {ColumnNames ""}} {

     if {[IsEmpty $SourceTableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) SourceTableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $TargetTableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TargetTableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     # Make sure target table does not already exist
     if {[SqliteTableExists $TargetTableName]} {
          error [format "$::ErrorMessage(INPUT_INVALID) Target table already exists." $TargetTableName] $::errorInfo $::ErrorCode(INPUT_INVALID)
     }
     set NameAndTypeList [SqliteColumnNameAndTypeList $SourceTableName]
     # Verify NameAndTypeList and ColumnNames have congruent length.
     if {([llength $ColumnNames] > 0) && ([llength $ColumnNames] * 2) != ([llength $NameAndTypeList])} {
          error [format "$::ErrorMessage(VARIABLE_CONTENTS_INVALID) Number of elements does not match number of columns in table." ColumnNames $ColumnNames] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }
     for {set i 0} {$i < [llength $ColumnNames]} {incr i} {
          lset NameAndTypeList [expr $i * 2] [lindex $ColumnNames $i]
     }
     RunSqlCreateTable $TargetTableName $NameAndTypeList
     # Copy from source to target
     set sql "INSERT INTO $TargetTableName SELECT * FROM $SourceTableName"
     QQ $sql
}

proc SqliteRenameColumn {TableName OldColumnName NewColumnName} {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $OldColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) OldColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $NewColumnName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) NewColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set NameAndTypeList [SqliteColumnNameAndTypeList $TableName]
     set Index [lsearch $NameAndTypeList $NewColumnName]
     if {$Index >= 0} {
          error [format "$::ErrorMessage(VARIABLE_CONTENTS_INVALID) A column with that name already exists." NewColumnName $NewColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }
     set Index [lsearch $NameAndTypeList $OldColumnName]
     if {$Index < 0} {
          error [format "$::ErrorMessage(VARIABLE_CONTENTS_INVALID) No such column found." OldColumnName $OldColumnName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     lset NameAndTypeList $Index $NewColumnName
     if {[SqliteTableExists gen_temp_rename_column_table]} {
          set sql "DROP TABLE gen_temp_rename_column_table"
          QQ $sql
     }
     RunSqlCreateTable gen_temp_rename_column_table $NameAndTypeList
     # Copy from source to target
     set sql "INSERT INTO gen_temp_rename_column_table SELECT * FROM $TableName"
     QQ $sql
     set sql "DROP TABLE $TableName"
     QQ $sql
     set sql "ALTER TABLE gen_temp_rename_column_table RENAME TO $TableName"
     QQ $sql
}

proc SqliteTableExists TableName {

     if {[IsEmpty $TableName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) TableName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     set sql "SELECT count(*) FROM sqlite_master WHERE tbl_name = '$TableName'"
     return [Q1 $sql]
}

proc StartsAndEndsWith {TargetString SearchValue} {

     if {[StartsWith $TargetString $SearchValue] && [EndsWith $TargetString $SearchValue]} {
          return 1
     } else {
          return 0
     }
}

proc StartsWith {TargetString SearchValue} {

     if {[string first $SearchValue $TargetString] == 0} {
          return 1
     } else {
          return 0
     }
}

proc String2File {StringValue OutFilePath} {

     # Open for writing
     set FilePointer [open $OutFilePath w]
     try {
          fconfigure $FilePointer -encoding utf-8
          
          # Write string to file
          puts -nonewline $FilePointer $StringValue
          # Clean up
          flush $FilePointer          
     } finally {
          close $FilePointer         
     }
}

proc StringContains {TargetString SearchValue} {

     if {[string first $SearchValue $TargetString] != -1} {
          return 1
     } else {
          return 0
     }
}

proc StringInsert {StringVariable InsertValue WhereAt} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[IsEmpty $WhereAt]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) WhereAt] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {$WhereAt eq "end"} {
          set WhereAt [expr [string length $String] - 1]
     }

     if {[IsNonNumeric $WhereAt]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) WhereAt $WhereAt] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)          
     }

     if {[IsNegative $WhereAt]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) WhereAt $WhereAt] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstPart [string range $String 0 [expr $WhereAt - 1]]
     set LastPart [string range $String $WhereAt end]
     set IndexDifference [expr $WhereAt - [string length $String]]
     set Spaces [string repeat " " [Ter [IsPositive $IndexDifference] {return $IndexDifference} {return 0}]]
     set String "[set FirstPart][set Spaces][set InsertValue][set LastPart]"
}

proc StringMid {TargetString Position {Count -1}} {

     if {[IsNonNumeric $Count]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Count] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }      

     if {$Count != -1} {
          if {[IsNonPositive $Count]} {
               error [format $::ErrorMessage(INPUT_NON_POSITIVE) $Count] $::errorInfo $::ErrorCode(INPUT_NON_POSITIVE)          
          }    
          if {$Position < 0} {
               set Position 0
          }
          return [string range $TargetString $Position [expr $Position + $Count - 1]]
     } else {
          return [string range $TargetString $Position end]
     }
}

proc SubtractFrom {VarName Value} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     set Var [expr $Var - $Value]
}

proc SumHhmmss ListValue {

     for {set i 0} {$i < [llength $ListValue]} {incr i} {
          set Element [lindex $ListValue $i]
          if {![IsHhmmss $Element]} {
               error [format $::ErrorMessage(LIST_HAS_INVALID_ELEMENT) ListValue $i $Element] $::errorInfo $::ErrorCode(LIST_HAS_INVALID_ELEMENT)
          }
     }

     set TotalSeconds 0
     foreach Element $ListValue {
          set ElementSeconds [Hhmmss2Seconds $Element]
          AddTo TotalSeconds $ElementSeconds
     }
     
     return [Seconds2Hhmmss $TotalSeconds]
}

proc SurroundEach {ListVariable String} {
     if {[string first @ $ListVariable] == 0} {
          UpvarExistingOrDie [string range $ListVariable 1 end] List
     } else {
          set List $ListVariable
     }

     set OutList {}
     foreach Element $List {
          lappend OutList "[set String][set Element][set String]"
     }
     set List $OutList
}

proc Swap {VarNameA VarNameB} {

     UpvarX $VarNameA A
     UpvarX $VarNameB B
     set Temp $A
     set A $B
     set B $Temp
     return
}

proc Ter {Condition IfTrue IfFalse} {

     set Result [uplevel 1 "expr {$Condition}"]
     if {$Result} {
          return [uplevel 1 "$IfTrue"]
     } else {
          return [uplevel 1 "$IfFalse"]
     }
}

proc TimeOfDay2Seconds StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     if {[catch {eval "clock scan {$String} -format $GenNS::TimeOfDayFormat"} String]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) StringVariable $StringVariable] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     return $String
}

proc TimeOfDayIsAfter {FirstTimeOfDay SecondTimeOfDay} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstSeconds [TimeOfDay2Seconds $FirstTimeOfDay]
     set SecondSeconds [TimeOfDay2Seconds $SecondTimeOfDay]
     if {$FirstSeconds > $SecondSeconds} {
          return 1
     } else {
          return 0
     }
}

proc TimeOfDayIsAt {FirstTimeOfDay SecondTimeOfDay} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     return [string equal $FirstTimeOfDay $SecondTimeOfDay]
}

proc TimeOfDayIsAtOrAfter {FirstTimeOfDay SecondTimeOfDay} {

     return [expr ![TimeOfDayIsBefore $FirstTimeOfDay $SecondTimeOfDay]]
}

proc TimeOfDayIsAtOrBefore {FirstTimeOfDay SecondTimeOfDay} {

     return [expr ![TimeOfDayIsAfter $FirstTimeOfDay $SecondTimeOfDay]]
}

proc TimeOfDayIsBefore {FirstTimeOfDay SecondTimeOfDay} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstSeconds [TimeOfDay2Seconds $FirstTimeOfDay]
     set SecondSeconds [TimeOfDay2Seconds $SecondTimeOfDay]
     if {$FirstSeconds < $SecondSeconds} {
          return 1
     } else {
          return 0
     }
}

proc TimeOfDayIsBetween {FirstTimeOfDay SecondTimeOfDay ThirdTimeOfDay {Option BothExclusive}} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $ThirdTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdTimeOfDay $ThirdTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     switch -regexp $Option {
          BothExclusive {
               set Sign1 <
               set Sign2 <
          }
          BothInclusive {
               set Sign1 <=
               set Sign2 <=
          }
          (LeftExclusive|RightInclusive) {
               set Sign1 <
               set Sign2 <=
          }
          (LeftInclusive|RightExclusive) {
               set Sign1 <=
               set Sign2 <
          }
          default {
               error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) Option $Option] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
          }
     }


     set FirstSeconds [TimeOfDay2Seconds $FirstTimeOfDay]
     set SecondSeconds [TimeOfDay2Seconds $SecondTimeOfDay]
     set ThirdSeconds [TimeOfDay2Seconds $ThirdTimeOfDay]

     if {[expr $SecondSeconds > $ThirdSeconds]} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondTimeOfDay ThirdTimeOfDay $SecondTimeOfDay $ThirdTimeOfDay] $::errorInfo $::ErrorCode(ARGUMENTS_INCOHERENT)
     }

     if {[expr ($SecondSeconds $Sign1 $FirstSeconds) && ($FirstSeconds $Sign2 $ThirdSeconds)]} {
          return 1
     } else {
          return 0
     }
}

proc ToBackslashes StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [regsub -all {\\\\} $String {\\}]     
     set String [regsub -all / $String {\\}]
}

proc ToDoubleBackslashes StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [regsub -all {\\} $String {\\\\}]
     set String [regsub -all / $String {\\\\}]

     return $String
}

proc ToForwardSlashes StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [regsub -all {\\\\} $String /]
     set String [regsub -all {\\} $String /]
     return $String
}

proc Today {} {

     return [eval "clock format [clock seconds] -format $GenNS::DateFormat"]
}

proc Tomorrow {} {

     return [eval "clock format [expr [clock seconds] + (3600*24)] -format $GenNS::DateFormat"]
}

proc UnlinkTclVariableFromRegistryValue {VarName RegistryKeyPath {RegistryValueName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryKeyPath]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryKeyPath] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {[IsEmpty $RegistryValueName]} {
          set RegistryValueName $VarName
     }

     set RegistryValueType [registry type $RegistryKeyPath $RegistryValueName]

     uplevel 1 "trace remove variable $VarName write \"UpdateRegistryValue $VarName {[ToDoubleBackslashes $RegistryKeyPath]} $RegistryValueType {$RegistryValueName}\""
}

proc UnlinkVarFromDbGlobal {VarName {DbGlobalName ""}} {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }
     if {[IsEmpty $DbGlobalName]} {
          set DbGlobalName $VarName
     }
     uplevel "trace remove variable $VarName write \{UpdateDbGlobal $VarName $DbGlobalName\}"
}

proc UnsetDbGlobal VarName {

     if {[IsEmpty $VarName]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) VarName] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     set ::sql "DELETE FROM $GenNS::GlobalsTable WHERE desc = '$VarName'"
     QQ $::sql
}

proc UpdateDbGlobal {VarName DbGlobalName args} {

     upvar #0 $VarName Var     
     SetDbGlobal $DbGlobalName $Var
}

proc UpdateRegistryValue {VarName RegistryKeyPath RegistryValueType {RegistryValueName ""} args} {

     if {[IsEmpty $RegistryValueName]} {
          set RegistryValueName $VarName
     }
     upvar #0 $VarName Var     
     registry set $RegistryKeyPath $RegistryValueName $Var $RegistryValueType
}

proc UpvarExistingOrDie {VarName Var} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {[IsEmpty $Var]} {
          error "Second argument is missing. Got empty string." $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }     
     if {[VarExistsInCaller $VarName 2]} {
          uplevel "upvar $VarName $Var"
     } else {
          error [format $::ErrorMessage(VARIABLE_NOT_FOUND) $VarName] $::errorInfo $::ErrorCode(VARIABLE_NOT_FOUND)
     }
     
     return
}

proc UpvarX {VarName Var {DefaultValue ""}} {

     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     if {[IsEmpty $Var]} {
          error "Second argument is missing. Got empty string." $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }     
     if {[VarExistsInCaller $VarName 2]} {
          uplevel 1 "upvar $VarName $Var"
     } else {
          uplevel 1 "upvar $VarName $Var"
          if {[NotEmpty $DefaultValue]} {
               uplevel 1 "set $Var $DefaultValue"
          } else {
               uplevel 1 "set $Var {}"
          }
     }
     
     return
}

proc VarExistsInCaller {VarName {LevelOffset 1}} {

     set Level [expr $LevelOffset + 1]
     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     set command "info exists $VarName"
     return [uplevel $Level $command]
}

proc Yesterday {} {

     set SecondsPerDay [expr 60*60*24]
     return [eval "clock format [expr [clock seconds] - $SecondsPerDay] -format $GenNS::DateFormat"]
}

proc GenCurrentVersion {} {
     puts 1.6.0
}
