package provide gen 1.0.1
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

proc ArrangeDict {DictValue Arrangement} {
     set Out [dict create]
     for {set i 0} {$i < [llength $Arrangement]} {incr i} {
          set Key [lindex $Arrangement $i]
          if {[dict exists $DictValue $Key]} {
               dict set Out $Key [dict get $DictValue $Key]
          }
     }
     
     return $Out
}

proc ChangeCasing {Value From To} {
     set Components {}
     set FromOptions {PascalCase mixedCase {Title Case} {hyphenated-lower} {HYPHENATED-UPPER} {phrase lower} {PHRASE UPPER} {snake_lower} {SNAKE_UPPER} {none}}
     set ToOptions {PascalCase mixedCase {Title Case} {hyphenated-lower} {HYPHENATED-UPPER} {phrase lower} {PHRASE UPPER} {snake_lower} {SNAKE_UPPER} {mashedlower} {MASHEDUPPER}}     
     switch -regexp $From {
          {PascalCase} {
               set Components [lreplace [split [regsub -all {([A-Z])} $Value { \1}] " "] 0 0]
          }
          {mixedCase} {
               set Value [::textutil::string::cap $Value]
               set Components [lreplace [split [regsub -all {([A-Z])} $Value { \1}] " "] 0 0]          
          }
          {Title Case} {
               set Components [split $Value " "]
          }
          {hyphenated-lower|hyphenated-case} {
               set Components [split $Value "-"]
          }
          {HYPHENATED-UPPER|HYPHENATED-CASE} {
               set Components [split $Value "-"]
          }
          {(phrase lower)|(phrase case)} {
               set Components [split $Value " "]
          }
          {(PHRASE UPPER)|(PHRASE CASE)} {
               set Components [split $Value " "]          
          }
          {snake_lower|snake_case} {
               set Components [split $Value "_"]          
          }
          {SNAKE_UPPER|SNAKE_CASE} {
               set Components [split $Value "_"]
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
     return $OutString
}

proc ChopLeft {TargetString {Count 1}} {
     return [string range $TargetString $Count end]

}

proc ChopRight {TargetString {Count 1}} {
     return [string range $TargetString 0 end-$Count]
}

proc CommaSeparatedStringToList {StringValue} {
     set Stage1 [split $StringValue ","]
     set Stage2 {}
     foreach Element $Stage1 {
          lappend Stage2 [string trim $Element]
     }
     return $Stage2
}

proc Decr {VarName} {
     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarX $VarName Var
     SetZeroIfEmpty Var
     if {[IsNonNumeric $Var]} {
          error [format $::ErrorMessage(VARIABLE_CONTENTS_INVALID) $VarName $Var] $::errorInfo $::ErrorCode(VARIABLE_CONTENTS_INVALID)
     }
     set Var [expr $Var - 1]
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

proc DoubleChop {StringValue {Count 1}} {
     return [ChopRight [ChopLeft $StringValue $Count] $Count]

}

proc EndsWith {TargetString SearchValue} {
     if {[IsEmpty $SearchValue]} {
          error $::ErrorMessage(SEARCH_STRING_EMPTY) $::errorInfo $::ErrorCode(SEARCH_STRING_EMPTY)
     }
     set LastStart [expr [string length $TargetString] - [string length $SearchValue]]
     set EndPart [string range $TargetString $LastStart end]
     if {[string equal $EndPart $SearchValue]} {
          return 1
     } else {
          return 0
     }
}

proc EvalList {ListValue} {
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

proc FindAndRemove {ListValue FindValue} {

     while {[set Index [lsearch $ListValue $FindValue]] != -1} {
          set ListValue [lreplace $ListValue $Index $Index]
     }
     return $ListValue
}

proc FirstOf {ListValue} {
     return [lindex $ListValue 0]
}

proc Flip {Value} {
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     } elseif {$Value == 1} {
          set Value 0
     } elseif {$Value == 0} {
          set Value 1
     } else {
          error [format $::ErrorMessage(INPUT_OUT_OF_RANGE) $Value] $::errorInfo $::ErrorCode(INPUT_OUT_OF_RANGE)      
     }
}

proc IsEmpty {StringValue} {
	if {[string equal $StringValue ""]} {
		return 1
	} else {
		return 0
	}
}

proc IsNegative {Value} {
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)
     }
     if {$Value < 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNonNegative {Value} {
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value >= 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNonNumeric {StringValue} {
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

proc IsNonPositive {Value} {
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value <= 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNonZero {Value} {
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value != 0} {
          return 1
     } else {
          return 0
     }
}

proc IsNumeric {StringValue} {
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

proc IsPositive {Value} {
     if {[IsNonNumeric $Value]} {
          error [format $::ErrorMessage(INPUT_NON_NUMERIC) $Value] $::errorInfo $::ErrorCode(INPUT_NON_NUMERIC)          
     }     
     if {$Value > 0} {
          return 1
     } else {
          return 0
     }
}

proc IsZero {Value} {
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

proc LastOf {ListValue} {
     set Index [expr [llength $ListValue] - 1]
     return [lindex $ListValue $Index]
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

proc Mash {StringValue} {
     return [string tolower [join $StringValue ""]]
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

proc NotEmpty {StringValue} {
	if {[string equal $StringValue ""] == 0} {
		return 1
	} else {
		return 0
	}
}

proc Prepend {StringVarName Value} {
     UpvarX $StringVarName String
     set String "[set Value][set String]"
     return $String
}

proc PrintVar {VarName} {
     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }
     UpvarExistingOrDie $VarName Var
     puts "$VarName is $Var"
     
     return
}

proc Raise {ListValue SublistLength} {
     if {![IsPositive $SublistLength]} {
          error [format $::ErrorMessage(INPUT_NON_POSITIVE) $SublistLength] $::errorInfo $::ErrorCode(INPUT_NON_POSITIVE)             
     }
     if {[llength $ListValue] < $SublistLength} {
          error [format $::ErrorMessage(INPUT_OUT_OF_RANGE) $SublistLength] $::errorInfo $::ErrorCode(INPUT_OUT_OF_RANGE)
     }
     if {[expr [llength $ListValue] % $SublistLength] != 0} {
          error [format $::ErrorMessage(CANNOT_FACTOR_INPUT_LIST) $SublistLength] $::errorInfo $::ErrorCode(CANNOT_FACTOR_INPUT_LIST)
     }
     set newlist {}
     for {set i 0} {$i < [llength $ListValue]} {set i [expr $i + $SublistLength]} {
          set nextlist {}
          for {set n 0} {$n < $SublistLength} {incr n} {
               lappend nextlist [lindex $ListValue [expr $i + $n]]			
          }
          lappend newlist $nextlist
     }
     return $newlist
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

proc RetZeroIfEmpty {Value} {
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

proc SetZeroIfEmpty {VarName} {
     if {[IsEmpty $VarName]} {
          error $::ErrorMessage(VARIABLE_NAME_EMPTY) $::errorInfo $::ErrorCode(VARIABLE_NAME_EMPTY)
     }

     UpvarX $VarName Var
     if {[IsEmpty $Var]} {
          set Var 0
     }
     
     return $Var
}

proc SplitAndTrim {TargetString {SplitValue " "} {TrimValue " "}} {
     set OutList {}
     foreach Element [split $TargetString $SplitValue] {
          set Trimmed [string trim $Element $TrimValue]
          if {[NotEmpty $Trimmed]} {
               lappend OutList $Trimmed
          }
     }
     return $OutList
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

proc SurroundEach {ListValue String} {
     set OutList {}
     foreach Element $ListValue {
          lappend OutList "[set String][set Element][set String]"
     }
     return $OutList
}

proc Swap {VarNameA VarNameB} {
     UpvarX $VarNameA A
     UpvarX $VarNameB B
     set Temp $A
     set A $B
     set B $Temp
     return
}

proc ToBackslashes {PathValue} {
     set PathValue [regsub -all {\\\\} $PathValue {\\}]     
     set PathValue [regsub -all / $PathValue {\\}]
}

proc ToDoubleBackslashes {PathValue} {
     set PathValue [regsub -all {\\} $PathValue {\\\\}]
     set PathValue [regsub -all / $PathValue {\\\\}]

     return $PathValue
}

proc ToForwardSlashes {PathValue} {
     set PathValue [regsub -all {\\\\} $PathValue /]
     set PathValue [regsub -all {\\} $PathValue /]
     return $PathValue
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

proc GenCurrentVersion {} {
     puts 1.0.0
}
