extends Panel

onready var gn_f = get_node("f")
onready var gn_text := get_node("text f")

var halted := false
var timer := Timer.new()

func _ready():
	add_child(timer)
	gn_f.rect_size.x = 0

func start(threshold: float, start_time: int):
	
	if is_instance_valid(timer):
		timer.stop()
	
	threshold *= 1000
	
	var i = get_i(start_time)
	
	r_update(i, threshold)
	
	while i < threshold and not halted:
		
		timer.start(gv.fps)
		yield(timer, "timeout")
		timer.stop()
		
		if halted:
			break
		
		i = get_i(start_time)
		
		r_update(i, threshold)
	
	i = 0

func get_i(start_time: int) -> int:
	return OS.get_ticks_msec() - start_time

func r_update(i, threshold):
	
	gn_f.rect_size.x = i / threshold * rect_size.x
	gn_text.text = fval.f(i / 1000) + "\n" + fval.f(threshold / 1000)

func halt():
	
	timer.stop()
	halted = true
