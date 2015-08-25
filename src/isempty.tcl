proc IsEmpty StringValue {

	if {[string equal $StringValue ""]} {
		return 1
	} else {
		return 0
	}
}