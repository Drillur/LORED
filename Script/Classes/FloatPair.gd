class_name FloatPair
extends Resource



signal filled
signal emptied

var current: Float
var total: Float



func _init(base_value: float, base_total: float):
	current = Float.new(base_value)
	total = Float.new(base_total)
	current.changed.connect(emit_changed)
	total.changed.connect(emit_changed)



func add(amount: float) -> void:
	current.add(amount)
	clamp_current()
	if current.equal(total.get_value()):
		filled.emit()


func subtract(amount: float) -> void:
	current.subtract(amount)
	clamp_current()
	if current.equal(0):
		emptied.emit()


func clamp_current() -> void:
	current.current = clampf(current.current, 0, total.current)



# - Get


func get_value() -> float:
	return current.get_value()


func get_total() -> float:
	return total.get_value()


func is_full() -> bool:
	return is_equal_approx(current.get_value(), total.get_value())


func is_not_full() -> bool:
	return not is_full()


func get_current_and_total_text() -> String:
	return current.get_text() + "/" + total.get_text()


func get_current_percent() -> float:
	return get_value() / get_total()
