proc EvalList ListValue {

	foreach Element $ListValue {
		eval $Element
	}
}