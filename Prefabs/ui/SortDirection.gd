extends Sprite



func flip():
	flip_v = not flip_v
	get_node("shadow").flip_v = flip_v


func reset():
	if flip_v:
		flip()


func hide():
	get_parent().hide()

func show():
	get_parent().show()
