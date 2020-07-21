extends MarginContainer



var key: String



func _ready() -> void:
	
	get_node("m/v/details").hide()



func _on_Select_mouse_entered() -> void:
	get_node("m/v/details").show()

func _on_Select_mouse_exited() -> void:
	get_node("m/v/details").hide()




func setup(_key):
	
	key = _key
	
	# icons
	get_node("m/v/h/icon/Sprite").texture = gv.sprite[gv.up[key].main_lored_target]
	get_node("m/v/details/h/icon/Sprite").texture = gv.sprite[gv.up[key].main_lored_target]
	
	# texts
	get_node("m/v/h/name").text = gv.up[key].name
	get_node("m/v/details/h/desc").text = gv.up[key].desc.f
