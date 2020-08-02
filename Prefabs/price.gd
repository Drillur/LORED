extends Panel

var content := {}
var numbers := {}
onready var rt = get_node("/root/Root")
onready var icon_text_prefab := preload("res://Prefabs/price_icon_text.tscn")

func init(f : Dictionary, type : String) -> int:
	
	var i := 0
	
	for x in f:
		
		content[x] = icon_text_prefab.instance()
		add_child(content[x])
		numbers[x] = f[x].t
		
		content[x].get_node("type").text = gv.g[x].name
		content[x].get_node("amount").add_color_override("font_color", gv.g[x].color)
		content[x].get_node("amount").text = fval.f(gv.g[x].r) + " / " + fval.f(numbers[x])
		content[x].get_node("time").add_color_override("font_color", gv.g[x].color)
		
		if gv.g[x].r > numbers[x]:
			content[x].get_node("time").hide()
			content[x].get_node("check").show()
		
		var xpos = 20 if type == "lored" else 38
		
		match type:
			"upgrade":
				if not i % 2 == 0: content[x].get_node("bg").hide()
				content[x].set_texture(gv.sprite[x])
				content[x].get_node("bg").rect_size.x += 38
				content[x].get_node("bg").rect_position.x -= 22
				#xpos = 38 # now set in xpos var delcaration
			"lored":
				if i % 2 == 0: content[x].get_node("bg").hide()
				content[x].set_texture(gv.sprite[x])
		
		content[x].position = Vector2(xpos, 25 + (i * 44))
		i += 1
	
	var buffer = 4
	if type == "upgrade": buffer = 6
	return i * 44 - buffer

