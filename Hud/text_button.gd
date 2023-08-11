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



func _ready() -> void:
	set_standard_theme()



func set_alternate_theme() -> void:
	button.theme = gv.theme_text_button_alternate


func set_standard_theme() -> void:
	button.theme = gv.theme_text_button
