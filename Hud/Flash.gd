extends Panel



@onready var timer = $Timer

var rate = 0.05



func _ready() -> void:
	hide()


func slow_flash(color: Color):
	rate = 0.08
	flash(color)
	


func flash(color: Color) -> void:
	if Engine.get_frames_per_second() < 60:
		queue_free()
		return
	
	show()
	
	var alpha = 0.25
	
	if not is_node_ready():
		await ready
	
	timer.wait_time = rate
	
	while not is_queued_for_deletion():
		
		self_modulate = Color(color.r, color.g, color.b, alpha)
		
		timer.start()
		await timer.timeout
		
		match alpha:
			0.25:
				alpha = 0.15
			0.15:
				alpha = 0.07
			0.07:
				queue_free()

