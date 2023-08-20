extends MarginContainer



signal exiting(wish, index)

func setup(wish: Wish) -> void:
	modulate = wish.objective.color
	wish.connect("just_ended", kill)
	if not is_node_ready():
		await ready
	var wait_time = randf_range(0.5, 1.5)#0.1 if gv.dev_mode else randf_range(0.5, 1.5)
	await get_tree().create_timer(wait_time).timeout
	exiting.emit(wish, get_index())
	queue_free()


func kill(_wish: Wish) -> void:
	queue_free()
