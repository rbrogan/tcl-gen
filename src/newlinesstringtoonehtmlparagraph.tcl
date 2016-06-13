proc NewlinesStringToOneHtmlParagraph String {

     set String [regsub {(\\r\\n|\\n)*$} $String ""]
     return "<p>[string map {\\r\\n <br> \\n <br>} $String]</p>"
}