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
	
	while true:
		
		self_modulate = Color(color.r, color.g, color.b, alpha)
		
		var t = Timer.new()
		t.set_wait_time(rate)
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		match alpha:
			0.25:
				alpha = 0.15
			0.15:
				alpha = 0.07
			0.07:
				queue_free()
