extends MarginContainer

onready var rt = get_node("/root/Root")

func init(_key: String) -> void:
	
	get_node("vbox/MarginContainer/VBoxContainer/HBoxContainer/icon/upgrade icon").init(_key)
	$vbox/MarginContainer/VBoxContainer/HBoxContainer/name.text = gv.up[_key].name
	
	if gv.up[_key].stage_key == gv.Tab.NORMAL:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Normal"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = Color(.8,.8,.8)
	elif gv.up[_key].stage_key == gv.Tab.EXTRA_NORMAL:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Extra-normal"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = Color(.8,.8,.8)
	elif gv.up[_key].stage_key == gv.Tab.MALIGNANT:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Malignant"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = gv.g["malig"].color
	elif gv.up[_key].stage_key == gv.Tab.RADIATIVE:
		$vbox/MarginContainer/VBoxContainer/type/text.text = "Radiative"
		$vbox/MarginContainer/VBoxContainer/type/bg.self_modulate = gv.g["tum"].color
