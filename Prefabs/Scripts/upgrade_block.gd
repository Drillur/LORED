extends MarginContainer

onready var rt = get_node("/root/Root")

func init(_key: String) -> void:
		
	$vbox/MarginContainer/VBoxContainer/HBoxContainer/icon/Sprite.texture = get_texture(_key)
	$vbox/MarginContainer/VBoxContainer/HBoxContainer/name.text = gv.up[_key].name
	
	var type: String = gv.up[_key].type
	if "s1n" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Normal"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = Color(.8,.8,.8)
	elif "s2n" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Extra-normal"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = Color(.8,.8,.8)
	elif "s1m" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Malignant"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = gv.g["malig"].color
	elif "s2m" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Radiative"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = gv.g["tum"].color

func get_texture(_key: String) -> Texture:
	
	# un-un-comment this line to only display the actual icon
	#return gv.sprite[gv.up[_key].icon]
	
	for x in gv.up[_key].requires:
		if not gv.up[x].have:
			return gv.sprite["unknown"]
	
	return gv.sprite[gv.up[_key].icon]
