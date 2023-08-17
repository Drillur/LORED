class_name Value
extends Resource



var saved_vars := [
	"current",
]

signal increased
signal decreased

var requires_sync := false:
	set(val):
		if requires_sync != val:
			requires_sync = val
			if requires_sync:
				emit_signal("changed")
var current: Big:
	get:
		sync()
		return current

var added := Big.new(0)
var subtracted := Big.new(0)
var multiplied := Big.new(1)
var divided := Big.new(1)
var from_level := Big.new(1)
var m_from_lored := Big.new(1)
var d_from_lored := Big.new(1)



func _init(base_value = 0.0) -> void:
	current = Big.new(base_value)
	current.connect("increased", emit_increase)
	current.connect("decreased", emit_decrease)
	current.connect("changed", emit_changed)


func emit_increase() -> void:
	emit_signal("increased")


func emit_decrease() -> void:
	emit_signal("decreased")


func set_to(amount) -> void:
	current.set_to(amount)


func change_base(new_base: float) -> void:
	current.change_base(new_base)


func add(amount) -> void:
	current.a(amount)


func subtract(amount: Big) -> void:
	if amount.greater_equal(current):
		current.set_to(0)
	else:
		current.s(amount)


func add_pending(amount: Big) -> void:
	current.add_pending(amount)


func subtract_pending(amount: Big) -> void:
	current.subtract_pending(amount)



func sync() -> void:
	if requires_sync:
		requires_sync = false
		current.reset()
		current.a(added)
		current.s(subtracted)
		current.m(multiplied)
		current.m(from_level)
		current.m(m_from_lored)
		current.d(divided)
		current.d(d_from_lored)


func get_text() -> String:
	return current.text


func get_value() -> Big:
	return current



func increase_added(amount) -> void:
	added.a(amount)
	requires_sync = true


func decrease_added(amount) -> void:
	added.s(amount)
	requires_sync = true


func increase_subtracted(amount) -> void:
	subtracted.a(amount)
	requires_sync = true


func decrease_subtracted(amount) -> void:
	subtracted.s(amount)
	requires_sync = true


func increase_multiplied(amount) -> void:
	multiplied.m(amount)
	requires_sync = true


func decrease_multiplied(amount) -> void:
	multiplied.d(amount)
	requires_sync = true


func increase_divided(amount) -> void:
	divided.m(amount)
	requires_sync = true


func decrease_divided(amount) -> void:
	divided.d(amount)
	requires_sync = true


func set_from_level(amount) -> void:
	from_level.set_to(amount)
	requires_sync = true


func set_d_from_lored(amount) -> void:
	d_from_lored.set_to(amount)
	requires_sync = true


func set_m_from_lored(amount) -> void:
	m_from_lored.set_to(amount)
	requires_sync = true



func reset():
	added.reset()
	subtracted.reset()
	multiplied.reset()
	divided.reset()
	from_level.reset()
	d_from_lored.reset()
	m_from_lored.reset()
	current.reset()




# - Get

func get_as_float() -> float:
	return current.toFloat()
