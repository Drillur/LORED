class_name TextButton
extends MarginContainer



@onready var button = $Button

signal pressed



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
	button.mouse_entered.connect(emit_mouse_entered)
	button.mouse_exited.connect(emit_mouse_exited)
	button.pressed.connect(emit_pressed)


func emit_mouse_entered() -> void:
	mouse_entered.emit()


func emit_mouse_exited() -> void:
	mouse_exited.emit()


func emit_pressed() -> void:
	pressed.emit()



func set_alternate_theme() -> void:
	button.theme = gv.theme_text_button_alternate


func set_standard_theme() -> void:
	button.theme = gv.theme_text_button
