extends MarginContainer


onready var full = get_node("base/full")
onready var notFull = get_node("base/not full")
onready var bar = get_node("base/not full/progress")

var key: String



func setup(_key: String):
	key = _key
	
	setColor(gv.COLORS[gv.g[key].fuel_source])
	
	update()

func setColor(_color: Color):
	get_node("base").modulate = _color

func getPercent() -> float:
	return gv.g[key].f.f.percent(gv.g[key].f.t)


func update():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		while full.visible:
			
			if getPercent() <= 0.998:
				isNotFull()
				break
			
			t.start(0.1)
			yield(t, "timeout")
		
		while notFull.visible:
			
			setBarSize()
			
			if getPercent() > 0.998:
				isFull()
				break
			
			t.start(gv.fps)
			yield(t, "timeout")
	
	t.queue_free()


func isFull():
	notFull.hide()
	full.show()
func isNotFull():
	full.hide()
	notFull.show()

func setBarSize(percent := getPercent()):
	bar.rect_size.y = min(percent * 13, 13)
	bar.rect_position.y = 20 - bar.rect_size.y


