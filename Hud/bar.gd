class_name Bar
extends MarginContainer



@onready var progress_bar = %"Progress Bar"
@onready var delta_bar = %"Delta Bar"
@onready var delta_timer = %Timer
@onready var texts = %Texts
@onready var text = %Text
@onready var texts_container = %TextsContainer
@onready var edge = %Edge
@onready var warning_marker = %"Warning Marker"
@onready var danger_marker = %"Danger Marker"

var color: Color:
	set(val):
		color = val
		progress_bar.modulate = color
		delta_bar.modulate = color

var using_texts := true
var markers_present := true
var animating_changes := false
var progress: float:
	set(val):
		progress = val
		set_progress()
var previous_progress: float
var delta_pass: float

var start_time: float
var threshold: float

var has_attribute := false
var attribute: ValuePair



func _on_resized():
	if using_texts:
		texts_container.size.x = size.x
	progress = progress
	if progress_bar.size.x > size.x:
		progress_bar.size.x = size.x
	progress_bar.size.y = size.y
	if animating_changes:
		delta_bar.size.y = size.y
#	if markers_present:
#		warning_marker.rect_size.y = size.y
#		danger_marker.rect_size.y = size.y



func _ready() -> void:
	delta_bar.hide()
	set_physics_process(false)
	await get_tree().create_timer(1).timeout
	if using_texts:
		if text.text == "":
			remove_texts()
	if not animating_changes:
		delta_bar.queue_free()



func animate_changes():
	animating_changes = true
	return self


func remove_markers():
	markers_present = false
	warning_marker.queue_free()
	danger_marker.queue_free()
	return self



func remove_texts():
	using_texts = false
	texts.queue_free()
	return self


func show_background():
	$bg.theme = gv.theme_standard
	return self


func hide_background():
	$bg.theme = gv.theme_invis
	return self


func hide_edge() -> void:
	edge.hide()


func show_edge() -> void:
	edge.show()


func attach_attribute(_attribute: ValuePair) -> void:
	attribute = _attribute
	has_attribute = true
	attribute.connect("changed", set_progress)
	set_progress()


func display_texts() -> void:
	attribute.connect("changed", update_text)
	update_text()
	texts.show()


func set_progress() -> void:
	if not is_node_ready():
		await ready
	if has_attribute:
		progress_bar.size.x = min(attribute.get_current_percent() * size.x, size.x)
	else:
		progress_bar.size.x = min(progress * size.x, size.x)
	if animating_changes:
		new_delta_animation()
		previous_progress = progress_bar.size.x



func new_delta_animation() -> void:
	delta_pass = Time.get_unix_time_from_system()
	var my_pass := delta_pass
	
	var _sign = sign(previous_progress - progress_bar.size.x)
	var delta: float = abs(previous_progress - progress_bar.size.x)
	delta_bar.size.x = delta
	delta_bar.show()
	
	var i := 0.0
	var i_gain = 0.025
	while delta_bar.size.x > 0:
		if my_pass != delta_pass:
			return
		if delta_bar.size.x <= 1:
			delta_bar.hide()
			return
		delta_bar.size.x = max(0, delta_bar.size.x - i)
		if _sign > 0:
			delta_bar.position.x = progress_bar.size.x
		else:
			delta_bar.position.x = progress_bar.size.x - 2 - delta_bar.size.x
		i += i_gain
		i_gain += 0.025
		delta_timer.start(0.016)
		await delta_timer.timeout




# - One-shot progression

func start(_threshold: float) -> void:
	start_time = Time.get_unix_time_from_system()
	threshold = _threshold
	set_physics_process(true)
	show()


func _physics_process(_delta) -> void:
	progress = (Time.get_unix_time_from_system() - start_time) / threshold


func stop() -> void:
	hide()
	set_physics_process(false)



func update_text() -> void:
	if not using_texts:
		return
	if not has_attribute:
		remove_texts()
		return
	text.text = "[b]" + attribute.get_current_text()
	if attribute.get_current_percent() <= lv.FUEL_DANGER:
		text.modulate = Color(1, 0, 0)
	elif attribute.get_current_percent() <= lv.FUEL_WARNING:
		text.modulate = Color(1, 1, 0)
	else:
		text.modulate = Color(1, 1, 1)



func set_initial_progress(value: float):
	for i in 2:
		await get_tree().physics_frame
	progress_bar.size = Vector2(
		value * size.x,
		size.y
	)
	previous_progress = progress_bar.size.x
	delta_bar.hide()
	delta_bar.size.y = size.y
	delta_pass = 0.0
