proc NotEmpty StringValue {

	if {[string equal $StringValue ""] == 0} {
		return 1
	} else {
		return 0
	}
}