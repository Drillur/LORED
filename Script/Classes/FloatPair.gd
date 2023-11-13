class_name FloatPair
extends Resource



var current: Float
var total: Float



func _init(base_value: float, base_total: float):
	current = Float.new(base_value)
	total = Float.new(base_total)



func add(amount: float) -> void:
	current.add(amount)
	clamp_current()


func subtract(amount: float) -> void:
	current.subtract(amount)
	clamp_current()


func clamp_current() -> void:
	current.current = clampf(current.current, current.base, total.current)



# - Get


func get_value() -> float:
	return current.get_value()


func get_total() -> float:
	return total.get_value()
