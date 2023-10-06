class_name Buff
extends Resource



signal ticked

signal debuffed
signal ended

var timer := Timer.new()

var tick_rate: Float
var ticks: Int

var endless := false



func _init() -> void:
	tick_rate.changed.connect(update_timer_wait_time)
	
	timer.wait_time = tick_rate.get_value()
	timer.timeout.connect(timer_timeout)
	gv.add_child(timer)



# - Setup


func set_ticks(val: int) -> void:
	if val == -1:
		endless = true
		ticks = Int.new(0)
	else:
		ticks = Int.new(val)
		ticks.set_to(0)


func set_tick_rate(val: float) -> void:
	tick_rate = Float.new(val)



# - Action


func start() -> void:
	timer.start()


func timer_timeout() -> void:
	ticked.emit()
	ticks.add(1)
	if endless:
		print("Tick! (%s)" % ticks.get_value(), ", ", timer.time_left)
	else:
		print("Tick! (%s/%s)" % [ticks.get_value(), ticks.base])
		if ticks.equal(ticks.base):
			remove()



func debuff() -> void:
	# removed prematurely
	debuffed.emit()
	remove()


func remove() -> void:
	timer.stop()
	timer.queue_free()
	ended.emit()



# - Signal


func update_timer_wait_time() -> void:
	timer.wait_time = tick_rate.get_value()




# - Get


func get_progress() -> float:
	return 1 - (timer.time_left / timer.wait_time)


func get_time_left() -> float:
	return timer.time_left


func get_ticks_remaining() -> int:
	return ticks.base - ticks.current
