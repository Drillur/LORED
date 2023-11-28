class_name Bar
extends MarginContainer



@onready var progress_bar = %"Progress Bar"
@onready var edge = %Edge
@onready var warning_marker = %"Warning Marker"
@onready var danger_marker = %"Danger Marker"
@onready var label = %Label
@onready var label_name = %LabelName

@export var kill_markers := false
@export var animate := false
@export var kill_background := false
@export var kill_text := true
@export var keep_text_centered := false

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

var bar_size := LoudInt.new(0)

var timer: Timer
var value: Resource



func _ready() -> void:
	if kill_markers:
		warning_marker.queue_free()
		danger_marker.queue_free()
	if kill_background:
		$bg.theme = gv.theme_invis
	if kill_text:
		$Control.queue_free()
	else:
		if keep_text_centered:
			center_text()
	resized.connect(_on_resized)
	call_deferred("_on_resized")
	set_process(false)
	bar_size.changed.connect(bar_size_changed)
#	if animate:
#		animate = false
#		set_deferred("animate", true)



func _process(_delta) -> void:
	progress = 1 - (timer.time_left / timer.wait_time)
	if not kill_text:
		label_name.text = "%s/%s" % [
			str(timer.wait_time - timer.time_left).pad_decimals(1),
			Big.get_float_text(timer.wait_time)
		]




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
	remove_value()
	value = _attribute
	value.changed.connect(update_progress)
	value.filled.connect(update_progress)
	call_deferred("update_progress")


func attach_float_pair(_float_pair: FloatPair) -> void:
	remove_value()
	value = _float_pair
	value.changed.connect(update_progress)
	value.filled.connect(update_progress)
	call_deferred("update_progress")


func remove_value() -> void:
	if value != null:
		value.changed.disconnect(update_progress)
		value.filled.disconnect(update_progress)
		value = null


func update_progress() -> void:
	# value_pair only
	progress = value.get_current_percent()
	if not kill_text:
		label.text = Big.get_float_text(value.current.get_value())


func center_text() -> void:
	label.get_parent().anchors_preset = Control.PRESET_FULL_RECT



# - Timer based


func attach_timer(_timer: Timer) -> void:
	if timer != null:
		timer = null
	timer = _timer
	set_process(true)


func remove_timer() -> void:
	timer = null
	set_process(false)
