class_name IconButton
extends MarginContainer



signal pressed

@onready var check = %Check
@onready var icon = %Icon
@onready var button = $Button
@onready var icon_shadow = %"Icon Shadow"

var color: Color:
	set(val):
		color = val
		icon.self_modulate = val
		button.modulate = val


func _ready():
	hide_check()
	set_theme_invis()



func _on_button_pressed():
	emit_signal("pressed")



func set_icon(_icon: Texture) -> void:
	icon.texture = _icon
	icon_shadow.texture = icon.texture


func set_icon_min_size(_size: Vector2) -> void:
	icon.custom_minimum_size = _size


func set_button_color(_color: Color) -> void:
	button.self_modulate = _color


func remove_check():
	check.queue_free()
	return self


func show_check() -> void:
	check.show()


func hide_check() -> void:
	check.hide()


func remove_icon_shadow():
	icon_shadow.queue_free()
	return self


func set_theme_standard() -> void:
	button.theme = gv.theme_standard


func set_theme_invis() -> void:
	button.theme = gv.theme_invis




func get_check() -> Node:
	return check
