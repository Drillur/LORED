extends MarginContainer

onready var rt = get_node("/root/Root")

func init(_key: String) -> void:
	
	get_node("vbox/MarginContainer/VBoxContainer/HBoxContainer/icon/upgrade icon").init(_key)
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
