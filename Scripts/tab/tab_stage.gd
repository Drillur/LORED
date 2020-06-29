extends Button

onready var rt = get_parent().get_owner()

var key = 0

func init(hotkey: String, sprite: Texture, unlck: bool) -> void:
	
	if not unlck: hide()
	
	$hotkey.text = "Stage " + hotkey
	$icon.texture = sprite
	
	var col : Color
	
	match hotkey:
		"1":
			key = KEY_1
			rect_position = Vector2(10, 600 - rect_size.y - 10)
			col = rt.r_lored_color("malig")
		"2":
			key = KEY_2
			rect_position = Vector2(10 + rect_size.x + 10, 600 - rect_size.y - 10)
			col = rt.r_lored_color("tum")
		"3":
			key = KEY_3
			rect_position = Vector2(10 + rect_size.x + 10 + rect_size.x + 10, 600 - rect_size.y - 10)
		"4":
			key = KEY_4
			rect_position = Vector2(10 + rect_size.x + 10 + rect_size.x + 10 + rect_size.x + 10, 600 - rect_size.y - 10)
	
	$hotkey.add_color_override("font_color", Color(col.r, col.g, col.b, 0.75))
	$selected.self_modulate = Color(col.r, col.g, col.b, 0.8)

func r_update(selected : bool):
	if selected: $selected.show()
	if not selected: $selected.hide()

func _on_button_down():
	rt.get_node("map").status = "no"
func _on_pressed():
	rt.b_tabkey(key)
