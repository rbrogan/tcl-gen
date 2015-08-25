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