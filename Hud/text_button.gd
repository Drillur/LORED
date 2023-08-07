class_name TextButton
extends MarginContainer



@onready var button = $Button


var color: Color:
	set(val):
		color = val
		modulate = color


var text: String:
	set(val):
		text = val
		button.text = val
