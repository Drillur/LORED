extends Panel

onready var rt = get_parent().get_owner()

var type : String
var confirm : int = 0

var flash := false
var flash_i := 0
var fps := 0.0

func init(typ : String, up_count_pos: int) -> void:
	
	type = typ
	
	$icon.set_texture(gv.sprite[type + "up"])
	
	var show_reset := true
	if "n" in type: show_reset = false
	if "m" in type:
		if rt.tabby["last stage"] == "1" and gv.up["RED NECROMANCY"].have and gv.up["RED NECROMANCY"].active:
			show_reset = false
		if "no" in gv.menu.f:
			if not gv.menu.f.split("no ")[1] == type[0] + type[1]: show_reset = false
	
	if show_reset:
		$reset.show()
		r_modulate_reset_button()
	
	match type:
		
		"s2n":
			$name.text = "Extra-normal%s"
			continue
		"s1n":
			$name.text = "Normal%s"
			continue
		"s2n", "s1n":
			$name.add_color_override("font_color", Color(.5,.5,.5))
			$up_count/amount.add_color_override("font_color", Color(.5, .5, .5))
		
		"s1m":
			$name.text = "Malignant%s"
			$name.add_color_override("font_color", Color(0.882353, 0.121569, 0.352941))
			$up_count/amount.add_color_override("font_color", Color(0.882353, 0.121569, 0.352941))
			$reset/icon.set_texture(gv.sprite[gv.up["METASTASIZE"].main_lored_target])
		"s2m":
			$name.text = "Radiative%s"
			$name.add_color_override("font_color", Color(1, .54, .54))
			$up_count/amount.add_color_override("font_color", Color(1, .54, .54))
			$reset/icon.set_texture(gv.sprite[gv.up["CHEMOTHERAPY"].main_lored_target])
	
	$name.text = $name.text % " upgrades"
	$up_count.rect_position.x = up_count_pos - $up_count.rect_size.x - 10
	w_update_owned_count()

func _physics_process(delta):
	
	if flash:
		if flash_i == 0:
			$reset/flash0.show()
			$reset/flash1.show()
		flash_i += 1
		if flash_i == 4: $reset/flash1.hide()
		if flash_i == 8:
			$reset/flash0.hide()
			flash = false
			flash_i = 0
	
	while true:
		
		if not $reset.visible: break
		
		fps += delta
		if fps < rt.FPS: break
		fps -= rt.FPS
		
		r_modulate_reset_button()
		
		break
	
	if confirm == 0: return
	confirm -= 1
	if confirm == 1: $reset/button/text.text = "Reset"

func r_modulate_reset_button():
	var reset_name : String
	
	match rt.tabby["last stage"]:
		"1":
			if "no" in gv.menu.f:
				reset_name = "SPREAD"
			else:
				reset_name = "METASTASIZE"
		"2":
			if "no" in gv.menu.f:
				reset_name = "RECOVER"
			else:
				reset_name = "CHEMOTHERAPY"
	
	$reset/button.modulate = rt.r_buy_color(1, reset_name)
func w_update_owned_count():
	
	var owned :int= gv.menu.upgrades_owned[type + "up"]
	var total :int= rt.upc[type + "up"].size()
	
	$up_count/amount.text = String(owned) + "/" + str(total)
func _on_back_button_down():
	rt.get_node("map").status = "no"

func _on_button_mouse_entered():
	# $reset/button
	match type:
		"s2m":
			if "ye" in gv.menu.f:
				rt.get_node("map/tip")._call("buy upgrade CHEMOTHERAPY")
			elif "no" in gv.menu.f and "s2" in gv.menu.f:
				rt.get_node("map/tip")._call("buy upgrade RECOVER")
		"s1m":
			if "ye" in gv.menu.f:
				rt.get_node("map/tip")._call("buy upgrade METASTASIZE")
			elif "no" in gv.menu.f and "s1" in gv.menu.f:
				rt.get_node("map/tip")._call("buy upgrade SPREAD")
func _on_button_mouse_exited():
	rt.get_node("map/tip")._call("no")


func _on_button_pressed():
	
	if "m" in gv.menu.tab and "ye" in gv.menu.f:
		
		var g = "malig"
		var up = "METASTASIZE"
		match rt.tabby["last stage"]:
			"2":
				g = "tum"
				up = "CHEMOTHERAPY"
	
	if confirm == 0:
		confirm = 100
		$reset/button/text.text = "Sure?"
		return
	
	confirm = 0
	
	$reset/button/text.text = "Reset"
	rt.get_node("map/tip")._call("no")
	
	match gv.menu.f:
		"ye":
			gv.menu.f = "no s" + rt.tabby["last stage"]
		_:
			rt.b_reset(int(gv.menu.f[4])) # will be 1 - 4

func _on_back_pressed():
	rt.b_tabkey(KEY_ESCAPE)
