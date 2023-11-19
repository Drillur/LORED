class_name Cooldown
extends Resource



var duration: Float
var timer := Timer.new()
var active := Bool.new(false)



func _init(_duration: float):
	duration = Float.new(_duration)
	duration.changed.connect(duration_changed)
	timer.one_shot = true
	timer.wait_time = _duration
	timer.timeout.connect(active.set_false)
	gv.add_child(timer)



# - Signal


func duration_changed() -> void:
	var ok
	if not timer.is_stopped():
		ok = timer.time_left
	timer.wait_time = duration.get_value()
	if not timer.is_stopped():
		print("timer time_left changed!!! went from ", ok, " to ", timer.time_left)



# - Action


func activate() -> void:
	timer.start()
	active.set_to(true)


func stop() -> void:
	timer.stop()
	active.set_to(false)



# - Get


func is_active() -> bool:
	return active.is_true()


func is_not_active() -> bool:
	return active.is_false()


func get_time_left() -> float:
	return timer.time_left


func get_duration() -> float:
	return duration.get_value()


func get_duration_text() -> String:
	return str(get_duration()).pad_decimals(1)


func get_progress() -> float: # 0.0 to 1.0
	if is_not_active():
		return 1.0
	return 1 - (get_time_left() / get_duration())


func get_time_left_text() -> String:
	var text = "[b][i][font_size=16]%s"
	if get_time_left() < 10:
		text = text % str(get_time_left()).pad_decimals(1)
		if get_time_left() < 0.5:
			text = "[color=#ffff00]" + text
		return text
	return text % str(round(get_time_left()))



# - Get (LORED-specific)


func is_nearly_or_already_inactive() -> bool:
	return (
		is_not_active()
		or get_time_left() < 0.5
	)
