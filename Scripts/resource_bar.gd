extends Panel

onready var rt = get_node("/root/Root")
var content := {}

func init():
	
	hide()
	
	for x in gv.g:
		content[x] = rt.prefab["resource_bar_text"].instance()
		add_child(content[x])
		content[x].init(x)
	
	# set position
	if true:
		
		var leftmost_xpos = 10
		var width = 59
		
		# s1
		if true:
			
			content["coal"].rect_position = Vector2(leftmost_xpos, 11)
			content["jo"].rect_position = Vector2(content["coal"].rect_position.x + width, 11)
			content["stone"].rect_position = Vector2(content["jo"].rect_position.x + width, 11)
			content["conc"].rect_position = Vector2(content["stone"].rect_position.x + width, 11)
			content["irono"].rect_position = Vector2(content["conc"].rect_position.x + width, 11)
			content["copo"].rect_position = Vector2(content["irono"].rect_position.x + width, 11)
			content["iron"].rect_position = Vector2(content["copo"].rect_position.x + width, 11)
			content["cop"].rect_position = Vector2(content["iron"].rect_position.x + width, 11)
			content["oil"].rect_position = Vector2(content["cop"].rect_position.x + width, 11)
			content["tar"].rect_position = Vector2(content["oil"].rect_position.x + width, 11)
			content["growth"].rect_position = Vector2(content["tar"].rect_position.x + width, 11)
			content["malig"].rect_position = Vector2(content["growth"].rect_position.x + width, 11)
		
		# s2
		if true:
			
			content["water"].rect_position = Vector2(leftmost_xpos, 11)
			content["tree"].rect_position = Vector2(content["water"].rect_position.x + width, 11)
			content["axe"].rect_position = Vector2(content["tree"].rect_position.x + width, 11)
			content["wood"].rect_position = Vector2(content["axe"].rect_position.x + width, 11)
			content["hard"].rect_position = Vector2(content["wood"].rect_position.x + width, 11)
			content["wire"].rect_position = Vector2(content["hard"].rect_position.x + width, 11)
			content["draw"].rect_position = Vector2(content["wire"].rect_position.x + width, 11)
			content["pulp"].rect_position = Vector2(content["draw"].rect_position.x + width, 11)
			content["paper"].rect_position = Vector2(content["pulp"].rect_position.x + width, 11)
			content["toba"].rect_position = Vector2(content["paper"].rect_position.x + width, 11)
			content["ciga"].rect_position = Vector2(content["toba"].rect_position.x + width, 11)
			content["carc"].rect_position = Vector2(content["ciga"].rect_position.x + width, 11)
			
			content["seed"].rect_position = Vector2(leftmost_xpos, 45)
			content["soil"].rect_position = Vector2(content["seed"].rect_position.x + width, 45)
			content["humus"].rect_position = Vector2(content["soil"].rect_position.x + width, 45)
			content["sand"].rect_position = Vector2(content["humus"].rect_position.x + width, 45)
			content["glass"].rect_position = Vector2(content["sand"].rect_position.x + width, 45)
			content["steel"].rect_position = Vector2(content["glass"].rect_position.x + width, 45)
			content["liq"].rect_position = Vector2(content["steel"].rect_position.x + width, 45)
			content["gale"].rect_position = Vector2(content["liq"].rect_position.x + width, 45)
			content["lead"].rect_position = Vector2(content["gale"].rect_position.x + width, 45)
			content["pet"].rect_position = Vector2(content["lead"].rect_position.x + width, 45)
			content["plast"].rect_position = Vector2(content["pet"].rect_position.x + width, 45)
			content["tum"].rect_position = Vector2(content["plast"].rect_position.x + width, 45)
	
	r_adjust()

func r_adjust():
	
	match rt.tabby["last stage"]:
		"1":
			rect_min_size.y = 33
			rect_size.y = 33
		"2":
			rect_min_size.y = 65
			rect_size.y = 65
	
	for x in gv.g:
		if gv.g[x].type[1] == rt.tabby["last stage"]:
			if rt.get_node("map/loreds").lored[x].visible: content[x].show()
		else:
			content[x].hide()
