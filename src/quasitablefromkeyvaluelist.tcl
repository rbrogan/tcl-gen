proc QuasiTableFromKeyValueList {List {KeyDivClassName "KeyDiv"} {ValueDivClassName "ValueDiv"}} {

     set OutString ""
     foreach {Key Value} $List {
          append OutString "<div class=\"$KeyDivClassName\">$Key</div>\n<div class=\"$ValueDivClassName\">$Value</div>\n\n"
     }
     return $OutString
}