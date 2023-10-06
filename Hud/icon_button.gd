class_name IconButton
extends MarginContainer



signal pressed
signal right_mouse_pressed

@onready var check = %Check
@onready var texture_rect = %Icon
@onready var button = $Button
@onready var icon_shadow = %"Icon Shadow"
@onready var autobuyer = %Autobuyer

@export var icon: Texture2D
@export var kill_autobuyer := false
@export var kill_check := false

var color: Color:
	set(val):
		color = val
		texture_rect.self_modulate = val
		button.modulate = val
		if is_instance_valid(autobuyer):
			autobuyer.modulate = val


func _ready():
	hide_check()
	set_theme_invis()
	autobuyer.hide()
	if kill_autobuyer:
		autobuyer.queue_free()
	if kill_check:
		check.queue_free()


func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_mouse_pressed.emit()


func _on_button_mouse_exited():
	mouse_exited.emit()


func _on_button_mouse_entered():
	mouse_entered.emit()


func _on_button_button_down():
	texture_rect.position.y = 1


func _on_button_button_up():
	texture_rect.position.y = 0




func set_icon(_icon: Texture) -> void:
	texture_rect.texture = _icon
	icon_shadow.texture = texture_rect.texture


func set_icon_min_size(_size: Vector2) -> void:
	texture_rect.custom_minimum_size = _size


func set_button_color(_color: Color) -> void:
	button.self_modulate = _color



func remove_optionals() -> IconButton:
	check.queue_free()
	icon_shadow.queue_free()
	autobuyer.queue_free()
	return self


func remove_check():
	check.queue_free()
	return self


func remove_icon_shadow():
	icon_shadow.queue_free()
	return self


func remove_autobuyer():
	autobuyer.queue_free()
	return self


func show_check() -> void:
	check.show()


func hide_check() -> void:
	check.hide()


func set_theme_standard() -> void:
	button.theme = gv.theme_standard


func set_theme_invis() -> void:
	button.theme = gv.theme_invis




func get_check() -> Node:
	return check

