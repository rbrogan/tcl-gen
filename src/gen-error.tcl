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
     PROC_NOT_FOUND -17
     ALREADY_EXISTS -18
     LIST_HAS_INVALID_ELEMENT -19
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
     PROC_NOT_FOUND {Could not find proc %s.}
     ALREADY_EXISTS {Value %s in variable %s already exists.}
     LIST_HAS_INVALID_ELEMENT {List variable %s at index %s has invalid value %s.}
}

