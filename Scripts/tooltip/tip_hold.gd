extends Panel

onready var rt = get_parent().rt
onready var input_text_prefab := preload("res://Prefabs/tooltip/tip_lored_input.tscn")

var input_text := {}

func init(b: Array, color: Color) -> int:
	
	$used_by/flair.self_modulate = color
	
	var ii := 0
	var i := 29
	for x in b:
		if not gv.g[x].active: continue
		input_text[x] = input_text_prefab.instance()
		input_text[x].init(rt.r_lored_color(x), gv.sprite[x], gv.g[x].name)
		$used_by.add_child(input_text[x])
		input_text[x].rect_position.y = i
		i += 38
		if ii % 2 == 0: input_text[x].get_node("bg").hide()
		ii += 1
		i += 3
	
	i -= 0
	return i# + 10
