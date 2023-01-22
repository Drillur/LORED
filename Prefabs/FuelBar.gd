extends MarginContainer


onready var full = get_node("%full")
onready var notFull = get_node("%not full")
onready var bar = get_node("%progress")
onready var text = get_node("%text")

var type: int

var stopped := false



func _ready() -> void:
	gv.connect("startGame", self, "update")

func setup(_type: int, updateAfterSetup = true):
	
	type = _type
	
	var fuelResource = lv.lored[type].fuelResource
	var fuelResourceShorthandKey = gv.shorthandByResource[fuelResource]
	setColor(gv.COLORS[fuelResourceShorthandKey])
	
	if updateAfterSetup:
		update()

func setColor(_color: Color):
	get_node("%base").modulate = _color

func getPercent() -> float:
	return lv.lored[type].currentFuelPercent


var updating = false
func update():
	
	var t = Timer.new()
	add_child(t)
	
	updating = true
	
	if gv.cur_session < 2:
		t.start(2)
		yield(t,"timeout")
	
	while not is_queued_for_deletion() and not stopped:
		
		while full.visible:
			
			if stopped:
				break
			
			var percent = getPercent()
			
			setText(percent)
			
			if percent <= 0.998:
				isNotFull()
				break
			
			t.start(0.1)
			yield(t, "timeout")
		
		while notFull.visible:
			
			if stopped:
				break
			
			var percent = getPercent()
			
			setText(percent)
			setBarSize(percent)
			
			if percent > 0.998:
				isFull()
				break
			
			t.start(gv.fps)
			yield(t, "timeout")
		
		if stopped:
			break
	
	t.queue_free()
	
	updating = false
	stopped = false


func stop():
	if updating:
		stopped = true
	full.show()


func isFull():
	notFull.hide()
	full.show()
func isNotFull():
	full.hide()
	notFull.show()


func setBarSize(percent := getPercent()):
	bar.rect_size.y = min(percent * 13, 13)
	bar.rect_position.y = 20 - bar.rect_size.y
func setText(percent := getPercent()):
	if text.visible:
		text.text = str(round(percent * 100)) + "%"


