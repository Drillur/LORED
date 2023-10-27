@tool
extends MarginContainer



@onready var background = %Background
@onready var label = %Label

@export var text: String:
	set(val):
		if text != val:
			text = val
			if not is_node_ready():
				await ready
			label.text = val

@export var color := Color(1, 1, 1):
	set(val):
		if color != val:
			color = val
			if not is_node_ready():
				await ready
			background.modulate = val


