extends MarginContainer


func go(level: int):
	if level == 1:
		get_node("level up").hide()
		get_node("joined").show()
	else:
		get_node("level up/VBoxContainer/Label2").text = str(level - 1) + " -> " + str(level)
	
	var t = Timer.new()
	add_child(t)
	var i = 0
	
	while not is_queued_for_deletion():
		
		t.start(0.1)
		yield(t,"timeout")
		
		rect_position.y -= 1
		i += 1
		
		if i == 15:
			queue_free()
	
	t.queue_free()
