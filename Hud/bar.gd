@tool
class_name Bar
extends MarginContainer



@onready var progress_bar = %"Progress Bar"
@onready var delta_bar = %"Delta Bar"
@onready var delta_timer = %Timer
@onready var edge = %Edge
@onready var warning_marker = %"Warning Marker"
@onready var danger_marker = %"Danger Marker"

@export var kill_markers := false
@export var animate := false
@export var kill_background := false

var color: Color:
	set(val):
		color = val
		progress_bar.modulate = color
		if animate:
			delta_bar.modulate = color

var progress: float:
	set(val):
		if progress != val:
			previous_progress = progress
			progress = val
			update_progress_bar()
var previous_progress := 0.0
var delta_speed := 0.0
var start_time := 0.0
var threshold: float

var has_attribute := false
var attribute: ValuePair



func _ready() -> void:
	if kill_markers:
		warning_marker.queue_free()
		danger_marker.queue_free()
	if kill_background:
		$bg.theme = gv.theme_invis
	progress_bar.set_deferred("size", Vector2(2, size.y))
	if not animate:
		delta_bar.hide()
		set_process(false)
		delta_bar.queue_free()



func _process(delta) -> void:
	if animate:
		if should_update_delta_bar():
			delta_speed += delta / 2
			delta_bar.size.x -= delta_speed
			fix_delta_bar_position()
			if not should_update_delta_bar():
				delta_speed = 0.0
	elif start_time != 0.0:
		progress = (Time.get_unix_time_from_system() - start_time) / threshold


func _on_resized():
	update_progress_bar()
	progress_bar.set_deferred("size", Vector2(progress_bar.size.x, size.y))
	if animate:
		delta_bar.set_deferred("size", Vector2(delta_bar.size.x, size.y))



func hide_edge() -> void:
	edge.hide()


func show_edge() -> void:
	edge.show()


func attach_attribute(_attribute: ValuePair) -> void:
	attribute = _attribute
	has_attribute = true
	attribute.changed.connect(update_progress)
	update_progress()



func update_progress() -> void:
	# attribute only
	progress = attribute.get_current_percent()


func update_progress_bar() -> void:
	progress_bar.size.x = min(progress * size.x, size.x)
	
	if animate:
		delta_bar.size.x = abs(progress - previous_progress) * size.x
		fix_delta_bar_position()



# - One-shot progression

func start(_threshold: float) -> void:
	start_time = Time.get_unix_time_from_system()
	threshold = _threshold
	set_process(true)
	show()



func should_update_delta_bar() -> bool:
	return delta_bar.size.x > 1


func fix_delta_bar_position() -> void:
	if previous_progress < progress:
		delta_bar.position.x = progress_bar.size.x - delta_bar.size.x
	else:
		delta_bar.position.x = progress_bar.size.x



func stop() -> void:
	start_time = 0.0
	set_process(false)
	hide()



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
