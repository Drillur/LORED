class_name LoudString
extends Resource



var base: String
var current: String:
	set(val):
		current = val
		changed.emit()



func _init(_base := "") -> void:
	base = _base
	reset()



# - Action


func reset() -> void:
	current = base


func set_to(val: String) -> void:
	current = val



# - Get


func get_value() -> String:
	return current
