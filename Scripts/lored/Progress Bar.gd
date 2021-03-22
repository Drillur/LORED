extends Panel

onready var gn_f = get_node("f")
onready var gn_task_text = get_node("task text")

var stop: bool

func _ready():
	gn_f.rect_size.x = 0

func start(threshold: float, start_time: int):
	
	stop = false
	
	threshold *= 1000
	
	var i := 0.0
	
	while i < threshold and not stop:
		
		i = get_i(start_time)
		
		r_update(i, threshold)
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()


func get_i(start_time: int) -> int:
	return OS.get_ticks_msec() - start_time

func r_update(i, threshold):
	
	gn_f.rect_size.x = min(i / threshold * rect_size.x, rect_size.x)

func stop():
	stop = true
	gn_f.rect_size.x = 0
	gn_task_text.text = ""
