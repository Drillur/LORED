extends MarginContainer

func setup(version: String):
	get_node("%version").text = version
	for note in gv.PATCH_NOTES[version]:
		var text = gv.SRC["labels/medium label"].instance()
		text.text = note
		text.autowrap = true
		get_node("%notes").add_child(text)
