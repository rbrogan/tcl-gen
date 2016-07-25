proc QuasiTableFromKeyValueList {List {KeyDivName "KeyDiv"} {ValueDivName "ValueDiv"}} {

     set OutString ""
     foreach {Key Value} $List {
          append OutString "<div class=\"$KeyDivName\">$Key</div>\n<div class=\"$ValueDivName\">$Value</div>\n\n"
     }
     return $OutString
}