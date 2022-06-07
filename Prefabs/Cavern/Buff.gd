extends MarginContainer


onready var bar = get_node("cooldown/bar")
onready var bar_flair = get_node("cooldown/bar/flair")
onready var bg = get_node("bg")

var type: int
var max_ticks: int
var ticks := 0

func _ready():
	bar.value = 0


func init(data: Dictionary):
	
	# called from: #zBuffApplied (Scenes/Cavern.gd::buffApplied())
	
	# data should have:
	# icon, max ticks, border color, type
	
	setIcon(data["icon"])
	updateMaxTicks(data["max ticks"])
	type = data["type"]
	yield(self, "ready")
	setBorderColor(data["border color"])
	_update(data["max ticks"])

func updateMaxTicks(_max_ticks: float):
	max_ticks = _max_ticks

func _update(_ticks: int):
	
	ticks = max_ticks - _ticks + 1
	
	bar.value = float(ticks) / float(max_ticks) * 100
	bar_flair.value = max(0, ticks - 1) / float(max_ticks) * 100

func clear():
	get_node("/root/Cavern").buffExpired(type)
	#hide()
	queue_free()



func setIcon(icon: Texture):
	get_node("m/icon/Sprite").set_texture(icon)
	
func setBorderColor(color: Color):
	bg.self_modulate = color

func throbBorder():
	
	var alpha = 1.1
	
	var t = Timer.new()
	add_child(t)
	
	while alpha > 0:
		
		alpha -= 0.1
		bg.self_modulate = Color(1,1,1,alpha)
		
		t.start(0.05)
		yield(t, "timeout")
	
	t.queue_free()
