package provide gen 1.3.0
package require sqlite3
package require Tclx
package require textutil::string
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
}

 namespace eval GenNS {
     variable DatabaseName "testdb"
     variable GlobalsTable "globals"
     variable DateFormat %Y-%m-%d     
     variable DatetimeFormat {{%Y-%m-%d %H:%M:%S}}
     variable TimeOfDayFormat %H:%M:%S
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

     set String [string range $String $Count end]

}

proc ChopRight {StringVariable {Count 1}} {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
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
               set sql "UPDATE $TableName SET $ColumnName = '$NewValue' WHERE id = $Id"
               QQ $sql
               incr TotalReplacements
          }
     }
     return $TotalReplacements
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

proc Dict2RegistryTree {DictValue RegistryRootKey {DeleteUnmatched 0}} {

     if {[IsEmpty $RegistryRootKey]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_EMPTY) RegistryRootKey] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_EMPTY)
     }

     if {![IsDict $DictValue]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) DictValue $DictValue] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     dict for {Name Value} $DictValue {
          set FullName "$RegistryRootKey\\$Name"
          # Check if the value is itself a dict
          if {[IsDict $Value]} {
               # If so, make a subkey and recurse
               registry set $FullName
               Dict2RegistryTree $Value $FullName $DeleteUnmatched
          } else {
               if {[RegistryExists $RegistryRootKey $Name]} {
                    set Type [registry type $RegistryRootKey $Name]
                    registry set $RegistryRootKey $Name $Value $Type
               } else {
                    registry set $RegistryRootKey $Name $Value
               }
          }
     }
     
     if {$DeleteUnmatched} {
          # If any keys/value are in the registry but not the dict,
          # delete them from the registry.
          foreach RegKey [registry keys $RegistryRoot] {
               if {![dict exists $DictValue $RegKey]} {
                    registry delete "$RegistryRoot\\$RegKey"
               }
          }
          
          foreach RegValueName [registry values $RegistryRoot] {
               if {![dict exists $DictValue $RegValueName]} {
                    registry delete $RegistryRoot $RegValueName
               }
          }
     }
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
          set Type [registry type $RegistryKeyPath $RegistryValueName]
     } else {
          set Type sz
     }

     registry set $RegistryKeyPath $RegistryValueName $Var $Type
     uplevel "trace add variable $VarName write \"UpdateRegistryValue $VarName {[ToDoubleBackslashes $RegistryKeyPath]} {$RegistryValueName}\""
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

proc Mash StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     set String [string tolower [join $String ""]]
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

     set Spaces [string repeat " " $IndentationSpaces]
     set MaxKeyLength 0
     dict for {Key Value} $DictValue {
          set CurrentKeyLength [string length $Key]
          set MaxKeyLength [Ter {$CurrentKeyLength > $MaxKeyLength} {return $CurrentKeyLength} {return $MaxKeyLength}]
     }
     dict for {Key Value} $DictValue {
          if {[IsDict $Value]} {
               puts [format "$Spaces%[set MaxKeyLength]s " $Key]
               PrintDict $Value [expr $MaxKeyLength + $IndentationSpaces + 1]
          } else {
               puts [format "$Spaces%[set MaxKeyLength]s $Value" $Key]
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
          if {![catch {registry values $KeyName $ValueName}]} {
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

     foreach RegValueName [registry values $CurrentRegKey] {
          set RegValueData [registry get $CurrentRegKey $RegValueName]
          dict set CurrentDict $RegValueName $RegValueData
     }

     foreach RegKey [registry keys $CurrentRegKey] {
          set DictValue [RegistryTree2Dict "$CurrentRegKey\\$RegKey"]
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

proc RetZeroIfEmpty Value {

     if {[IsEmpty $Value]} {
          return 0
     } else {
          return $Value
     }
}

proc Run {Script args} {

     # Clear and populate argv with args
     global argv
     set argv {}
     
     for {set i 0} {$i < [llength $args]} {incr i} {
          set Argument [lindex $args $i]
          lappend argv $Argument
     }
     
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
          RunSqlEnter $GenNS::GlobalsTable "desc '$VarName'" "textvalue '' intvalue null realvalue null"
     } elseif {[string is double $Value]} {
          # If it is a double then for the intvalue, enter a truncated value.
          RunSqlEnter $GenNS::GlobalsTable "desc '$VarName'" "realvalue $Value intvalue [::tcl::mathfunc::floor $Value] textvalue '$Value'"
     } elseif {[string is integer $Value]} {
          # If it is an integer then for the realvalue add ".0"
          RunSqlEnter $GenNS::GlobalsTable "desc '$VarName'" "intvalue $Value realvalue [set Value].0 textvalue '$Value'"
     } else {
          # Any other string enter as text with the intvalue and realvalue as null.
          RunSqlEnter $GenNS::GlobalsTable "desc '$VarName'" "textvalue '$Value' intvalue null realvalue null"
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

     set Result [uplevel 1 "expr $Condition"]
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

proc TimeOfDayIsBetween {FirstTimeOfDay SecondTimeOfDay ThirdTimeOfDay} {

     if {![IsTimeOfDay $FirstTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) FirstTimeOfDay $FirstTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $SecondTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) SecondTimeOfDay $SecondTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     if {![IsTimeOfDay $ThirdTimeOfDay]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) ThirdTimeOfDay $ThirdTimeOfDay] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }

     set FirstSeconds [TimeOfDay2Seconds $FirstTimeOfDay]
     set SecondSeconds [TimeOfDay2Seconds $SecondTimeOfDay]
     set ThirdSeconds [TimeOfDay2Seconds $ThirdTimeOfDay]

     if {$SecondSeconds > $ThirdSeconds} {
          error [format $::ErrorMessage(ARGUMENTS_INCOHERENT) SecondTimeOfDay ThirdTimeOfDay $SecondTimeOfDay $ThirdTimeOfDay] $::errorInfo $::ErrorCode(ARGUMENTS_INCOHERENT)
     }

     if {($FirstSeconds > $SecondSeconds) && ($FirstSeconds < $ThirdSeconds)} {
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
     uplevel "trace remove variable $VarName write \"UpdateRegistryValue $VarName {[ToDoubleBackslashes $RegistryKeyPath]} {$RegistryValueName}\""
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

proc UpdateRegistryValue {VarName RegistryKeyPath {RegistryValueName ""} args} {

     if {[IsEmpty $RegistryValueName]} {
          set RegistryValueName $VarName
     }
     upvar #0 $VarName Var     
     registry set $RegistryKeyPath $RegistryValueName $Var
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
          uplevel "upvar $VarName $Var"
     } else {
          uplevel "upvar $VarName $Var"
          if {[NotEmpty $DefaultValue]} {
               uplevel "set $Var $DefaultValue"
          } else {
               uplevel "set $Var {}"
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
     puts 1.3.0
}
