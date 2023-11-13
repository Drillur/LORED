class_name Bar
extends MarginContainer



@onready var progress_bar = %"Progress Bar"
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

var progress: float:
	set(val):
		if progress != val:
			progress = val
			if animate:
				var tween = get_tree().create_tween()
				tween.tween_property(
					bar_size, "current", min(progress * size.x, size.x), 0.5
				).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			else:
				bar_size.set_to(min(progress * size.x, size.x))

var bar_size := Int.new(0)

var timer: Timer
var value_pair: ValuePair



func _ready() -> void:
	if kill_markers:
		warning_marker.queue_free()
		danger_marker.queue_free()
	if kill_background:
		$bg.theme = gv.theme_invis
	resized.connect(_on_resized)
	call_deferred("_on_resized")
	set_process(false)
	bar_size.changed.connect(bar_size_changed)
#	if animate:
#		animate = false
#		set_deferred("animate", true)



func _process(_delta) -> void:
	progress = 1 - (timer.time_left / timer.wait_time)




func _on_resized():
	progress_bar.size.y = size.y
	if animate:
		var tween = get_tree().create_tween()
		tween.tween_property(
			bar_size, "current", min(progress * size.x, size.x), 0.5
		).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func bar_size_changed() -> void:
	progress_bar.size.x = bar_size.get_value()



# - Action


func stop() -> void:
	set_process(false)
	progress = 0.0


func hide_edge() -> void:
	edge.hide()


func show_edge() -> void:
	edge.show()


func attach_attribute(_attribute: ValuePair) -> void:
	if value_pair != null:
		value_pair.changed.disconnect(update_progress)
	value_pair = _attribute
	value_pair.changed.connect(update_progress)
	call_deferred("update_progress")



func update_progress() -> void:
	# value_pair only
	progress = value_pair.get_current_percent()



# - Timer based


func attach_timer(_timer: Timer) -> void:
	if timer != null:
		timer = null
	timer = _timer
	set_process(true)

