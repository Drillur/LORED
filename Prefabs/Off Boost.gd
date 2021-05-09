extends MarginContainer


onready var rt = get_node("/root/Root")

onready var timer = $Timer
onready var bar_f = $"v/ct xp/c"
onready var bar = $"v/ct xp"
onready var gn_time = $v/h2/time

var base_time: float

var exists := true



func setup(_base_time: float) -> void:
	
	if _base_time == 0.0:
		stop()
		return
	
	get_node("v/h/d").text = fval.f(gv.off_d) + "x"
	base_time = _base_time
	
	go()

func go():
	
	gn_time.text = gv.parse_time(rt.get_node("misc/Off").time_left)
	
	while exists and rt.get_node("misc/Off").time_left > 0:
		
		timer.start(1)
		yield(timer, "timeout")
		
		if not is_instance_valid(rt.get_node("misc/Off")):
			stop()
			return
		
		bar_f.rect_size.x = min(rt.get_node("misc/Off").time_left / base_time * bar.rect_size.x, bar.rect_size.x)
		
		if rt.get_node("misc/Off").paused:
			gn_time.text = "Paused"
		else:
			gn_time.text = gv.parse_time(rt.get_node("misc/Off").time_left)
		
		if gv.off_locked:
			$v/h2/warning.show()
		else:
			$v/h2/warning.hide()
	
	stop()

func stop():
	exists = false
	queue_free()


