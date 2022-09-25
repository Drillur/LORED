extends Panel

func _ready() -> void:
	hide()

var rate = 0.05

func slowFlash(color := Color(1, 0, 0)):
	rate = 0.08
	flash(color)

func flash(color := Color(1, 0, 0)) -> void:
	
	show()
	
	var alpha = 0.25
	
	var t = Timer.new()
	t.set_wait_time(rate)
	add_child(t)
	
	while not is_queued_for_deletion():
		
		self_modulate = Color(color.r, color.g, color.b, alpha)
		
		t.start()
		yield(t, "timeout")
		
		match alpha:
			0.25:
				alpha = 0.15
			0.15:
				alpha = 0.07
			0.07:
				queue_free()
	
	t.queue_free()
