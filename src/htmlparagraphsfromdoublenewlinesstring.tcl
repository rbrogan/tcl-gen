proc HtmlParagraphsFromDoubleNewlinesString StringVariable {
     if {[string first @ $StringVariable] == 0} {
          UpvarExistingOrDie [string range $StringVariable 1 end] String
     } else {
          set String $StringVariable
     }

     return "<p>[string map {{\n\n} {</p><p>}} $String]</p>"
}