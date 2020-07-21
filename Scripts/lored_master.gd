extends Node

const src = {
	LORED = preload("res://Prefabs/lored.tscn"),
	SPEECH = preload("res://Prefabs/speech.tscn"),
}

onready var rt = get_owner()

var lored : Dictionary
var speech : Dictionary

var pad := Vector2(130 + 30, 165)


func _ready() -> void:
	
	gv.connect("lored_updated", self, "r_update_lored")
	
	# loreds
	if true:
		
		# stage 1
		if true:
			
			gv.g["coal"] = LORED.new("Coal", "s1 bur bore ", {}, { "stone" : Ob.Num.new(5.0) }, 200.0)
			gv.g["stone"] = LORED.new("Stone", "s1 bur bore key ", {}, { "iron" : Ob.Num.new(25.0), "cop" : Ob.Num.new(15.0) }, 150.0)
			gv.g["irono"] = LORED.new("Iron Ore", "s1 bur bore ", {}, { "stone" : Ob.Num.new(8.0) }, 250.0)
			gv.g["copo"] = LORED.new("Copper Ore", "s1 bur bore ", {}, { "stone" : Ob.Num.new(8.0) }, 250.0)
			gv.g["iron"] = LORED.new("Iron", "s1 bur fur ", { "irono" : Ob.Num.new() }, { "stone" : Ob.Num.new(9.0), "cop" : Ob.Num.new(8.0) }, 300.0)
			gv.g["cop"] = LORED.new("Copper","s1 bur fur ", { "copo" : Ob.Num.new() }, { "stone" : Ob.Num.new(9.0), "iron" : Ob.Num.new(8.0) }, 300.0)
			gv.g["growth"] = LORED.new("Growth", "s1 ele fur key ", { "iron" : Ob.Num.new(), "cop" : Ob.Num.new()}, { "stone" : Ob.Num.new(900.0) }, 400.0)
			gv.g["conc"] = LORED.new("Concrete", "s1 bur fur key ", {"stone" : Ob.Num.new()}, {"iron" : Ob.Num.new(90.0), "cop" : Ob.Num.new(150.0)}, 600.0)
			gv.g["jo"] = LORED.new("Joules", "s1 bur fur ", {"coal" : Ob.Num.new()}, {"conc" : Ob.Num.new(25.0)}, 500.0)
			gv.g["malig"] = LORED.new("Malignancy", "s1 ele fur key ", {"growth" : Ob.Num.new(), "tar" : Ob.Num.new()}, {"iron" : Ob.Num.new(900.0), "cop" : Ob.Num.new(900.0), "conc" : Ob.Num.new(50.0)}, 300.0)
			gv.g["tar"] = LORED.new("Tarballs", "s1 ele fur ", {"growth" : Ob.Num.new(), "oil" : Ob.Num.new()}, {"iron" : Ob.Num.new(350.0), "malig" : Ob.Num.new(10.0)}, 250.0)
			gv.g["oil"] = LORED.new("Oil", "s1 bur bore ", {}, {"cop" : Ob.Num.new(250.0), "conc" : Ob.Num.new(250.0)}, 30.0, 0.075)
		
		# stage 2
		if true:
			
			# main
			gv.g["tum"] = LORED.new("Tumors", "s2 ele fur ", {"growth": Ob.Num.new(10.0), "malig": Ob.Num.new(5.0), "carc": Ob.Num.new(3.0)}, {"hard" : Ob.Num.new(50.0), "wire" : Ob.Num.new(150.0), "glass": Ob.Num.new(150.0), "steel": Ob.Num.new(100.0)}, 1000.0)
			
			# hardwood
			gv.g["hard"] = LORED.new("Hardwood", "s2 ele fur ", {"wood": Ob.Num.new(3.0), "conc": Ob.Num.new()}, {"iron" : Ob.Num.new(3500.0), "conc" : Ob.Num.new(350.0), "wire": Ob.Num.new(35.0)}, 275.0)
			gv.g["wood"] = LORED.new("Wood", "s2 ele fur ", {"axe": Ob.Num.new(0.2), "tree": Ob.Num.new(0.04)}, {"cop" : Ob.Num.new(4500.0), "wire": Ob.Num.new(15.0)}, 300.0, 25.0)
			gv.g["axe"] = LORED.new("Axes", "s2 ele fur ", {"hard": Ob.Num.new(0.8), "steel": Ob.Num.new(0.25)}, {"iron" : Ob.Num.new(1000.0), "hard": Ob.Num.new(55.0)}, 420.0)
			
			# wire
			gv.g["draw"] = LORED.new("Draw Plate", "s2 bur fur ", {"steel": Ob.Num.new(0.5)}, {"iron" : Ob.Num.new(900.0), "conc": Ob.Num.new(300.0), "wire": Ob.Num.new(20.0)}, 600.0)
			gv.g["wire"] = LORED.new("Wire", "s2 ele fur ", {"cop": Ob.Num.new(5.0), "draw": Ob.Num.new(0.4)}, {"stone" : Ob.Num.new(13000.0), "glass": Ob.Num.new(30.0)}, 300.0)
			
			# glass
			gv.g["glass"] = LORED.new("Glass", "s2 ele fur ", {"sand": Ob.Num.new(6.0)}, {"cop" : Ob.Num.new(6000.0), "steel": Ob.Num.new(40.0)}, 350.0)
			gv.g["sand"] = LORED.new("Sand", "s2 bur fur ", {"humus": Ob.Num.new(0.6)}, {"iron" : Ob.Num.new(700.0), "cop": Ob.Num.new(2850.0)}, 250.0, 2.5)
			
			# steel
			gv.g["steel"] = LORED.new("Steel", "s2 ele fur ", {"liq": Ob.Num.new(8.0)}, {"iron" : Ob.Num.new(15000.0), "cop" : Ob.Num.new(3000.0), "hard": Ob.Num.new(35.0)}, 800.0)
			gv.g["liq"] = LORED.new("Liquid Iron", "s2 ele fur ", {"iron": Ob.Num.new(10.0)}, {"conc": Ob.Num.new(900.0), "steel" : Ob.Num.new(25.0)}, 250.0)
			
			# life
			gv.g["tree"] = LORED.new("Trees", "s2 ele fur ", {"water": Ob.Num.new(8.0), "seed": Ob.Num.new()}, {"growth": Ob.Num.new(150.0), "soil" : Ob.Num.new(25.0)}, 1200.0)
			gv.g["water"] = LORED.new("Water", "s2 bur bore ", {}, {"stone": Ob.Num.new(2500.0), "wood" : Ob.Num.new(80.0)}, 200.0)
			gv.g["seed"] = LORED.new("Seeds", "s2 bur fur ", {"water": Ob.Num.new(2)}, {"cop": Ob.Num.new(800.0), "tree" : Ob.Num.new(2.0)}, 300.0)
			gv.g["soil"] = LORED.new("Soil", "s2 bur fur ", {"humus": Ob.Num.new(1.5)}, {"conc": Ob.Num.new(1000.0), "hard" : Ob.Num.new(40.0)}, 300.0)
			gv.g["humus"] = LORED.new("Humus", "s2 ele fur ", {"growth": Ob.Num.new(0.5), "water": Ob.Num.new()}, {"iron": Ob.Num.new(600.0), "cop" : Ob.Num.new(600.0), "glass" : Ob.Num.new(30.0)}, 275.0)
			
			# carc
			gv.g["carc"] = LORED.new("Carcinogens", "s2 ele fur ", {"malig": Ob.Num.new(3.0), "ciga": Ob.Num.new(6.0), "plast": Ob.Num.new(5.0)}, {"growth": Ob.Num.new(8500.0), "conc": Ob.Num.new(2000.0), "steel": Ob.Num.new(150.0), "lead": Ob.Num.new(800.0)}, 450.0)
			gv.g["plast"] = LORED.new("Plastic", "s2 ele fur ", {"coal": Ob.Num.new(5.0), "pet": Ob.Num.new()}, {"stone": Ob.Num.new(10000.0), "tar": Ob.Num.new(700.0)}, 375.0)
			gv.g["pet"] = LORED.new("Petroleum", "s2 bur fur ", {"oil": Ob.Num.new(3.0)}, {"iron": Ob.Num.new(3000.0), "cop" : Ob.Num.new(4000.0), "glass" : Ob.Num.new(130.0)}, 300.0)
			gv.g["ciga"] = LORED.new("Cigarettes", "s2 ele fur ", {"tar": Ob.Num.new(4.0), "toba": Ob.Num.new(), "paper": Ob.Num.new(0.25)}, {"hard" : Ob.Num.new(50.0), "wire" : Ob.Num.new(120.0)}, 155.0)
			gv.g["toba"] = LORED.new("Tobacco", "s2 bur fur ", {"water": Ob.Num.new(3.0), "seed": Ob.Num.new()}, {"soil": Ob.Num.new(3.0), "hard": Ob.Num.new(15.0)}, 500.0)
			gv.g["paper"] = LORED.new("Paper", "s2 bur fur ", {"pulp": Ob.Num.new(0.6)}, {"conc": Ob.Num.new(1200.0), "steel": Ob.Num.new(15.0)}, 320.0)
			gv.g["pulp"] = LORED.new("Wood Pulp", "s2 ele fur ", {"stone": Ob.Num.new(2.0), "wood": Ob.Num.new(1.0)}, {"wire": Ob.Num.new(15.0), "glass": Ob.Num.new(30.0)}, 400.0, 5.0)
			gv.g["lead"] = LORED.new("Lead", "s2 bur fur ", {"gale": Ob.Num.new()}, {"stone": Ob.Num.new(400.0), "growth": Ob.Num.new(800.0)}, 300.0)
			gv.g["gale"] = LORED.new("Galena", "s2 bur bore ", {}, {"stone": Ob.Num.new(1100.0), "wire": Ob.Num.new(200.0)}, 250.0)
		
		
		for x in gv.g:
			
			gv.g[x].short = x
			
			for v in gv.g:
				if gv.g[v].b.size() == 0: continue
				if not x in gv.g[v].b.keys(): continue
				gv.g[x].used_by.append(v)
			
			gv.g[x].benefactors["haste list"] = []
			gv.g[x].benefactors["out list"] = []
			gv.g[x].benefactors["add list"] = []
			gv.g[x].benefactors["burn list"] = []
			gv.g[x].benefactors["cost list"] = []
			gv.g[x].benefactors["crit list"] = []




func init():
	
	for x in gv.g:
		lored[x] = src.LORED.instance()
		add_child(lored[x])
		lored[x].init(x)
		for v in lored[x].fps:
			lored[x].fps[v]["set"] = true
		if x in "stone coal":
			lored[x].show()
	
	# s1
	if true:
		
		# 0
		lored["coal"].rect_position = Vector2(400 - 130 - 15, 600 - lored["coal"].rect_size.y - 300)
		lored["stone"].rect_position = Vector2(lored["coal"].rect_position.x + pad.x, lored["coal"].rect_position.y)
		lored["jo"].rect_position = Vector2(lored["coal"].rect_position.x - pad.x, lored["coal"].rect_position.y)
		lored["conc"].rect_position = Vector2(lored["stone"].rect_position.x + pad.x, lored["stone"].rect_position.y)
		
		# 1
		lored["irono"].rect_position = Vector2(lored["stone"].rect_position.x, lored["stone"].rect_position.y - pad.y)
		lored["copo"].rect_position = Vector2(lored["irono"].rect_position.x + pad.x, lored["irono"].rect_position.y)
		lored["oil"].rect_position = Vector2(lored["jo"].rect_position.x, lored["irono"].rect_position.y)
		
		# 2
		lored["iron"].rect_position = Vector2(lored["irono"].rect_position.x, lored["irono"].rect_position.y - pad.y)
		lored["cop"].rect_position = Vector2(lored["copo"].rect_position.x, lored["iron"].rect_position.y)
		lored["tar"].rect_position = Vector2(lored["oil"].rect_position.x, lored["iron"].rect_position.y)
		
		# 3
		lored["malig"].rect_position = Vector2(lored["coal"].rect_position.x, lored["iron"].rect_position.y - pad.y)
		lored["growth"].rect_position = Vector2(lored["cop"].rect_position.x, lored["malig"].rect_position.y)
	
	# s2
	if true:
		
		# 0
		lored["water"].rect_position = Vector2(1200 + 400 - 65, lored["coal"].rect_position.y)
		lored["seed"].rect_position = Vector2(lored["water"].rect_position.x - pad.x, lored["water"].rect_position.y)
		lored["soil"].rect_position = Vector2(lored["water"].rect_position.x + pad.x, lored["water"].rect_position.y)
		
		# 1
		lored["tree"].rect_position = Vector2(lored["water"].rect_position.x, lored["water"].rect_position.y - pad.y)
		lored["toba"].rect_position = Vector2(lored["seed"].rect_position.x - pad.x, lored["tree"].rect_position.y)
		lored["humus"].rect_position = Vector2(lored["soil"].rect_position.x + pad.x, lored["tree"].rect_position.y)
		
		# 2
		lored["wood"].rect_position = Vector2(lored["tree"].rect_position.x, lored["tree"].rect_position.y - pad.y)
		lored["pulp"].rect_position = Vector2(lored["wood"].rect_position.x - pad.x, lored["wood"].rect_position.y)
		lored["paper"].rect_position = Vector2(lored["pulp"].rect_position.x - pad.x, lored["wood"].rect_position.y)
		lored["axe"].rect_position = Vector2(lored["wood"].rect_position.x + pad.x, lored["wood"].rect_position.y)
		lored["sand"].rect_position = Vector2(lored["humus"].rect_position.x, lored["wood"].rect_position.y)
		
		# 3
		lored["hard"].rect_position = Vector2(lored["axe"].rect_position.x, lored["axe"].rect_position.y - pad.y)
		lored["ciga"].rect_position = Vector2(lored["paper"].rect_position.x, lored["hard"].rect_position.y)
		lored["glass"].rect_position = Vector2(lored["hard"].rect_position.x + pad.x, lored["hard"].rect_position.y)
		
		# 4
		lored["steel"].rect_position = Vector2(lored["glass"].rect_position.x, lored["glass"].rect_position.y - pad.y)
		lored["wire"].rect_position = Vector2(lored["hard"].rect_position.x, lored["steel"].rect_position.y)
		lored["tum"].rect_position = Vector2(lored["wire"].rect_position.x - pad.x, lored["steel"].rect_position.y)
		lored["carc"].rect_position = Vector2(lored["tum"].rect_position.x - pad.x, lored["steel"].rect_position.y)
		lored["plast"].rect_position = Vector2(lored["carc"].rect_position.x - pad.x, lored["steel"].rect_position.y)
		
		# 5
		lored["liq"].rect_position = Vector2(lored["steel"].rect_position.x, lored["steel"].rect_position.y - pad.y)
		lored["draw"].rect_position = Vector2(lored["wire"].rect_position.x, lored["liq"].rect_position.y)
		lored["pet"].rect_position = Vector2(lored["plast"].rect_position.x, lored["liq"].rect_position.y)
		
		# 6
		lored["lead"].rect_position = Vector2(lored["carc"].rect_position.x, lored["liq"].rect_position.y - pad.y)
		lored["gale"].rect_position = Vector2(lored["lead"].rect_position.x + pad.x, lored["lead"].rect_position.y)

func w_call_speech(sprite : Texture, color : Color, position : Vector2) -> void:

	speech[1] = src.SPEECH.instance()
	speech[1].init(sprite, color)
	speech[1].position = position
	get_parent().add_child(speech[1])

func r_update_hold(first_time := false) -> void:
	
	for x in lored:
		
		if not first_time:
			if not gv.g[x].active: continue
			if lored[x].get_node("hold").visible: continue
		
		if lored[x].r_hold_lord():
			
			lored[x].get_node("halt").rect_size.x = 31
			lored[x].get_node("hold").show()
		
		else:
			
			lored[x].get_node("halt").rect_size.x = 64
			lored[x].get_node("hold").hide()

func r_update_autobuy(f := ["all"]) -> void:
	
	if f[0] == "all":
		f.clear()
		for v in gv.g:
			f.append(v)
	
	for x in f:
		
		if not lored[x].my_autobuyer in gv.up.keys(): continue
		
		if gv.up[lored[x].my_autobuyer].active():
			
			lored[x].get_node("autobuywheel").show()
		
		else:
			
			lored[x].get_node("autobuywheel").hide()

func r_update_lb() -> void:
	for x in lored:
		lored[x].limit_break(gv.g[x])
func r_update_lb_flash() -> void:
	for x in lored:
		lored[x].update_lb_colors()


func r_update_lored(_lored, _updated_stat) -> void:
	
	lored[_lored].fps[_updated_stat].set = true
