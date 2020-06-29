extends Button

onready var rt = get_node("/root/Root")

var key = 0
var path : String

func init(get_key, sprite : Texture, unlocked: bool, color: Color, get_path: String) -> void:
	
	if not unlocked: hide()
	
	key = get_key
	path = get_path
	
	$icon.texture = sprite
	
	match key:
		KEY_Q:
			$hotkey.text = "q"
			rect_position = Vector2(10, 600 - 10 - 38 - 10 - rect_size.y)
		KEY_W:
			$hotkey.text = "w"
			rect_position = Vector2(10 + rect_size.x + 10, 600 - 10 - 38 - 10 - rect_size.y)
		KEY_E:
			$hotkey.text = "e"
			rect_position = Vector2(10 + rect_size.x + 10 + rect_size.x + 10, 600 - 10 - 38 - 10 - rect_size.y)
			key = KEY_Q
		KEY_R:
			$hotkey.text = "r"
			rect_position = Vector2(10 + rect_size.x + 10 + rect_size.x + 10 + rect_size.x + 10, 600 - 10 - 38 - 10 - rect_size.y)
			key = KEY_W
	
	self_modulate = color
	$hotkey.add_color_override("font_color",color)
	



func _pressed():
	rt.tabby["last stage"] = path
	rt.b_tabkey(key)

func _on_b_upgrade_tab_button_down():
	rt.get_node("map").status = "no"
