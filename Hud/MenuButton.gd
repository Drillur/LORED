@tool
class_name _MenuButton
extends MarginContainer



signal pressed

@onready var texture_rect = %Icon
@onready var button = $Button
@onready var label = %Label
@onready var texts = $Texts

@export var icon: Texture2D
@export var text: String:
	set(val):
		text = val
		if not is_node_ready():
			await ready
		if text == "GameName":
			label.text = "[b][i]LORED\n[color=#000000cc]" + ProjectSettings.get("application/config/Version")
		else:
			label.text = text

@export var color := Color.WHITE:
	set(val):
		color = val
		if not is_node_ready():
			await ready
		button.modulate = val
		texture_rect.modulate = val
		if val == Color.BLACK:
			label.modulate = val

@export var display_node: Node
@export var drop_down: Node



func _ready():
	color = color
	
	set_icon(icon)
	if drop_down != null:
		button.disconnect("button_down", _on_button_button_down)
		button.disconnect("button_up", _on_button_button_up)
		drop_down.visibility_changed.connect(drop_down_visibility_changed)
		drop_down.hide()
		drop_down_visibility_changed()
	
	if (get_parent().name == "Save" or "Save" in name) and color == Color.WHITE:
		await SaveManager.save_color_changed
		color = SaveManager.save_file_color



func _on_button_pressed():
	if drop_down != null:
		drop_down.visible = not drop_down.visible
	elif display_node != null:
		display_node.visible = not display_node.visible
	
	pressed.emit()
	
	match name:
		"Save Game":
			if gv.current_clock - SaveManager.last_save_clock < 3:
				return
			SaveManager.save_game()


func drop_down_visibility_changed() -> void:
	if drop_down.visible:
		texture_rect.rotation_degrees = 0
		texture_rect.position.y = 0
	else:
		texture_rect.rotation_degrees = -90
		texture_rect.position = Vector2(0, 24)


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



func set_text_visibility(val: bool) -> void:
	label.visible = val


func set_color(val: Color) -> void:
	color = val
