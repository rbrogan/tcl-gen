proc LastOf ListValue {

     set Index [expr [llength $ListValue] - 1]
     return [lindex $ListValue $Index]
}