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