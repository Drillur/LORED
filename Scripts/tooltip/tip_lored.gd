extends Panel

onready var rt = get_parent().get_parent().get_owner()
onready var input_text_prefab := preload("res://Prefabs/tooltip/tip_lored_input.tscn")

var input_height_in_tooltip := 0

var input_text := {}

func init(type : String, inactive := false):

	# active or inactive information
	$name.text = gv.g[type].name
	$name/icon.set_texture(gv.sprite[type])

	# out
	if inactive:
		$misc.show()
		$misc.text = "A new LORED!"
		$crit.hide()
		$haste.hide()
		$lv.hide()
		$out.hide()
		return

	# in
	if "fur" in gv.g[type].type:
		
		$input.show()
		$input/flair.modulate = rt.r_lored_color(type)
		
		var ii := 0
		var i := 29
		for x in gv.g[type].b:
			input_text[x] = input_text_prefab.instance()
			input_text[x].init(rt.r_lored_color(x), gv.sprite[x], gv.g[x].name)
			$input.add_child(input_text[x])
			input_text[x].rect_position.y = i
			i += 38
			if ii % 2 == 0: input_text[x].get_node("bg").hide()
			ii += 1
			i += 3
		
		i -= 4
		input_height_in_tooltip = i# +2

	# text
	$lv.text = "lv" + String(gv.g[type].level)

	# color
	var lored_color :Color= rt.r_lored_color(type)
	$lv.add_color_override("font_color", lored_color)

