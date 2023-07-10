class_name Value
extends Reference



var base: Big
var current: Big

var updated := true
var text: String setget , get_text



func _init(base_value) -> void:
	
	base = Big.new(base_value)
	current = Big.new(base_value)





func set_to(amount) -> void:
	current = Big.new(amount)
	updated = true


func add(amount) -> void:
	current.a(amount)
	updated = true


func subtract(amount: Big) -> void:
	if amount.greater(current):
		current = Big.new(0)
	else:
		current.s(amount)
	updated = true



func get_text() -> String:
	if updated:
		text = current.toString()
		updated = false
	return text



func reset():
	current = Big.new(base)
