extends MarginContainer

onready var rt = get_node("/root/Root")

func init(_key: String) -> void:
	
	$vbox/MarginContainer/VBoxContainer/HBoxContainer/icon/Sprite.texture = get_texture(_key)
	$vbox/MarginContainer/VBoxContainer/HBoxContainer/name.text = gv.up[_key].name
	
	var type: String = gv.up[_key].type
	if "s1 nup" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Normal"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = Color(.8,.8,.8)
	elif "s2 nup" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Extra-normal"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = Color(.8,.8,.8)
	elif "s1 mup" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Malignant"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = rt.r_lored_color("malig")
	elif "s2 mup" in type:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Radiative"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = rt.r_lored_color("tum")

func get_texture(_key) -> Texture:
	
	# un-un-comment this line to only display the actual icon
	#return gv.sprite[gv.up[_key].main_lored_target]
	
	
	
	if gv.up[_key].requires == "":
		return gv.sprite[gv.up[_key].main_lored_target]
	
	if gv.up[gv.up[_key].requires].have:
		return gv.sprite[gv.up[_key].main_lored_target]
	
	return gv.sprite["unknown"]
