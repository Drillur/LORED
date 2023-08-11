extends MarginContainer



func setup(wish: Wish) -> void:
	modulate = wish.objective.color
	if not is_node_ready():
		await ready
	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	queue_free()
