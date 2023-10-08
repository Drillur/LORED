class_name Buff
extends Resource



const REFRESH_ON_NEW_STACK := true

signal ticked

signal refreshed
signal debuffed
signal ended

var type: int
var key: String

var object # LORED, Unit, anything!

var timer := Timer.new()

var name: String

var tick_rate: Float
var ticks: Int
var stacks: Int

var endless := false



func _init() -> void:
	tick_rate.changed.connect(update_timer_wait_time)
	
	timer.wait_time = tick_rate.get_value()
	timer.timeout.connect(timer_timeout)
	gv.add_child(timer)
	
	if REFRESH_ON_NEW_STACK and not endless:
		stacks.changed.connect(refresh)



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


func set_stack_limit(val: int) -> void:
	stacks = Int.new(val)
	stacks.set_to(1)



# - Action


func start() -> void:
	timer.start()


func timer_timeout() -> void:
	ticks.add(1)
	ticked.emit()
	if endless:
		print("Tick! (%s)" % ticks.get_value())
	else:
		print("Tick! (%s/%s)" % [ticks.get_value(), ticks.base])
		if ticks.equal(ticks.base):
			remove()


func refresh() -> void:
	ticks.set_to(-1)
	refreshed.emit()


func add_stacks(amount: int) -> void:
	if stacks.get_value() + amount > get_stack_limit():
		stacks.set_to(get_stack_limit())
	else:
		stacks.add(amount)
	print("Stacks increased to ", stacks.text)


func remove_stacks(amount: int) -> void:
	stacks.subtract(amount)



func debuff() -> void:
	# removed with a cleanse-type ability
	debuffed.emit()
	remove()


func remove() -> void:
	timer.stop()
	timer.queue_free()
	ended.emit()
	Buffs.free_buff(self)



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


func get_stack_limit() -> int:
	return stacks.base
