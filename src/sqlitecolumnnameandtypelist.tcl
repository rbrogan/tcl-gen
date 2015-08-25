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