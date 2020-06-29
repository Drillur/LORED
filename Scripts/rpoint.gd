extends Button

onready var rt = get_parent().get_parent().rt

func _pressed():

	var xpos : int
	match rt.tabby["last stage"]:
		"1": xpos = 0
		"2": xpos = -1200

	rt.get_node("map").set_global_position(Vector2(xpos, -rt.get_node("map/loreds").get_child(get_parent().get_index()).rect_position.y + 250))
	rt.get_node("map").status = "no"
