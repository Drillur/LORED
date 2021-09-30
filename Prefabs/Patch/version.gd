extends VBoxContainer

var cont := []

func setup(key: String) -> void:
	
	get_node("h/label").text = key
	
	var i = 0
	for x in gv.PATCH_NOTES[key]:
		cont.append(gv.SRC["patch entry"].instance())
		cont[i].get_node("label").text = x
		add_child(cont[i])
		i += 1
		
