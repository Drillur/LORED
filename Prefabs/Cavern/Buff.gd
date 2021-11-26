extends MarginContainer


onready var bar = get_node("cooldown/bar")
onready var bar_flair = get_node("cooldown/bar/flair")

var duration: float
var i: float

func _ready():
	bar.value = 0


func init(data: Dictionary):
	
	setIcon(data["icon"])
	setBorderColor(data["border color"])
	updateDuration(data["duration"])
	yield(self, "ready")
	_update(data["type"])

func updateDuration(_duration: float):
	duration = _duration
	i = 0.0

func _update(type: int):
	
	var t = Timer.new()
	add_child(t)
	
	while i < duration:
		
		bar.value = i / duration * 100
		
		i += gv.fps
		t.start(gv.fps)
		yield(t, "timeout")
	
	t.queue_free()
	get_node("/root/Root").cav.buffExpired(type)
	#hide()
	queue_free()


func _on_bar_value_changed(value):
	
	bar_flair.value = value - 1

func setIcon(icon: Texture):
	get_node("m/icon/Sprite").set_texture(icon)
	
func setBorderColor(color: Color):
	get_node("bg").self_modulate = color
