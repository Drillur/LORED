class_name IconButton
extends MarginContainer



signal pressed

@onready var check = %Check
@onready var icon = %Icon
@onready var button = $Button
@onready var icon_shadow = %"Icon Shadow"
@onready var autobuyer = %Autobuyer

var color: Color:
	set(val):
		color = val
		icon.self_modulate = val
		button.modulate = val
		if is_instance_valid(autobuyer):
			autobuyer.modulate = val


func _ready():
	hide_check()
	set_theme_invis()
	autobuyer.hide()



func _on_button_pressed():
	emit_signal("pressed")


func _on_button_mouse_exited():
	mouse_exited.emit()


func _on_button_mouse_entered():
	mouse_entered.emit()


func _on_button_button_down():
	icon.position.y = 1


func _on_button_button_up():
	icon.position.y = 0




func set_icon(_icon: Texture) -> void:
	icon.texture = _icon
	icon_shadow.texture = icon.texture


func set_icon_min_size(_size: Vector2) -> void:
	icon.custom_minimum_size = _size


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

