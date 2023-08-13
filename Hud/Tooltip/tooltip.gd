extends MarginContainer



@onready var content = $"Tooltip Content"
@onready var bg = $bg

var type: int



func setup(_type: int) -> void:
	type = _type

