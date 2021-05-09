extends Panel

onready var gn_f = get_node("f")
#onready var gn_task_text = get_node("task text")
onready var timer = get_node("Timer")

var stop: bool

func _ready():
	gn_f.rect_size.x = 0

func start(threshold: float, start_time: int):
	
	stop()
	
	stop = false
	
	threshold *= 1000
	
	var i := get_i(start_time)
	
	while i < threshold and not stop:
		
		gn_f.rect_size.x = min(i / threshold * rect_size.x, rect_size.x)
		
		timer.start(gv.fps)
		yield(timer, "timeout")
		
		i = get_i(start_time)




func get_i(start_time: int) -> int:
	return OS.get_ticks_msec() - start_time


func stop():
	
	stop = true
	gn_f.rect_size.x = 0
	#gn_task_text.text = ""
	timer.stop()
