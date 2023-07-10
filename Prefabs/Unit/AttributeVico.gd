class_name AttributeVico
extends Panel



onready var progress: Panel = $"%progress"
onready var delta_progress: Panel = $"%delta"
onready var label: Label = $"%Label"
onready var edge: Panel = $"%edge"
onready var flair: Label = $"%flair"
onready var h_box_container: HBoxContainer = $HBoxContainer



enum Type {
	HEALTH,
	BLOOD,
	MANA,
}

var type: int
var delta_pass: int
var previous_progress: float

var key: String

var attribute: Attribute

var delta_timer := Timer.new()



func _ready() -> void:
	add_child(delta_timer)



func setup(_type: int, _attribute: Attribute) -> void:
	type = _type
	key = Type.keys()[type]
	
	call("setup_" + key)
	attribute = _attribute
	attribute.assign_vico(self)
	
	previous_progress = progress.rect_size.x
	delta_progress.hide()
	
	h_box_container.rect_size.x = rect_size.x
	update()


func setup_HEALTH():
	flair.text = "hp"


func setup_BLOOD():
	flair.text = "blood"
	set_self_modulates(Color(1, 0, 0))


func setup_MANA():
	flair.text = "mana"
	set_self_modulates(gv.COLORS["MANA"])



func update():
	update_progress()
	update_text()
	update_color()


func update_progress():
	progress.rect_size = Vector2(
		min(attribute.get_current_percent() * rect_size.x, rect_size.x),
		rect_size.y
	)
	new_delta_animation()
	previous_progress = progress.rect_size.x


func new_delta_animation() -> void:
	delta_pass = OS.get_ticks_msec()
	var my_pass := delta_pass
	
	var _sign = sign(previous_progress - progress.rect_size.x)
	var delta: float = abs(previous_progress - progress.rect_size.x)
	delta_progress.rect_size.x = delta
	delta_progress.show()
	
	var i := 0.0
	var i_gain = 0.025
	while delta_progress.rect_size.x > 0:
		if my_pass != delta_pass:
			return
		if delta_progress.rect_size.x < 1:
			delta_progress.hide()
			return
		delta_progress.rect_size.x = max(0, delta_progress.rect_size.x - i)
		if _sign > 0:
			delta_progress.rect_position.x = progress.rect_size.x
		else:
			delta_progress.rect_position.x = progress.rect_size.x - 2 - delta_progress.rect_size.x
		i += i_gain
		i_gain += 0.025
		delta_timer.start(gv.fps)
		yield(delta_timer, "timeout")


func update_text():
	if type == Type.HEALTH and attribute.get_current_percent() == 1.0:
		label.text = "100%"
		return
	label.text = attribute.get_current_text()


func update_color():
	var update_color_method = "update_color_" + key
	if has_method(update_color_method):
		call(update_color_method)


func update_color_HEALTH():
	var health_percent := attribute.get_current_percent()
	var health_color_fade := get_health_color_fade_by_percent(health_percent)
	set_self_modulates(health_color_fade)


func get_health_color_fade_by_percent(percent: float) -> Color:
	var r: float = min(2 - (percent / 0.5), 1.0)
	var g: float = min(percent / 0.5, 1.0)
	return Color(r, g, 0.0)


func set_self_modulates(color: Color) -> void:
	progress.set_self_modulate(color)
	edge.set_self_modulate(color)
	delta_progress.set_self_modulate(color)
