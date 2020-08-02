extends MarginContainer



var src := {
	lored = preload("res://Prefabs/lored/LORED.tscn"),
	hbox = preload("res://Prefabs/template/HBoxContainer 10 separation.tscn"),
}

var cont := {}


func _ready():
	gv.connect("lored_updated", self, "r_update_lored")


func setup():
	
	setup_s1()
	setup_s2()

func setup_s2():
	
	var i = 0
	add_stuffs("carc", i)
	add_stuffs("tum", i)
	
	i += 1
	add_stuffs("plast", i)
	add_stuffs("toba", i)
	add_stuffs("ciga", i)
	
	i += 1
	add_stuffs("pet", i)
	add_stuffs("pulp", i)
	add_stuffs("paper", i)
	
	i += 1
	add_stuffs("gale", i)
	add_stuffs("lead", i)
	
	i += 1
	add_stuffs("draw", i)
	add_stuffs("wire", i)
	
	i += 1
	add_stuffs("sand", i)
	add_stuffs("glass", i)
	
	i += 1
	add_stuffs("liq", i)
	add_stuffs("steel", i)
	
	i += 1
	add_stuffs("axe", i)
	add_stuffs("wood", i)
	add_stuffs("hard", i)
	
	i += 1
	add_stuffs("seed", i)
	add_stuffs("tree", i)
	add_stuffs("soil", i)
	
	i += 1
	add_stuffs("water", i)
	add_stuffs("humus", i)

func add_stuffs(key: String, i: int):
	
	cont[key] = src.lored.instance()
	cont[key].setup(key)
	
	if not "h2" + str(i) in cont.keys():
		cont["h2" + str(i)] = src.hbox.instance()
		get_node("sc/v/s" + gv.g[key].type[1]).add_child(cont["h2" + str(i)])
	
	cont["h2" + str(i)].add_child(cont[key])

func setup_s1():
	
	var i = 0
	for x in gv.stats.g_list["s1"]:
		
		cont[x] = src.lored.instance()
		cont[x].setup(x)
		
		# add children
		if i % 2 == 0:
			cont["h1" + str(i)] = src.hbox.instance()
			get_node("sc/v/s" + gv.g[x].type[1]).add_child(cont["h1" + str(i)])
			cont["h1" + str(i)].add_child(cont[x])
		else:
			cont["h1" + str(i - 1)].add_child(cont[x])
		
		i += 1
	
	cont["coal"].show()
	cont["stone"].show()

func r_autobuy(specific_lored := ""):
	
	if specific_lored != "":
		autobuy_check(specific_lored)
		return
	
	for x in gv.g:
		autobuy_check(x)

func autobuy_check(key: String):
	
	cont[key].get_node(cont[key].gnbuy + "/autobuywheel").visible = gv.up[gv.g[key].autobuyer_key].active()


func r_update_lored(_lored, _updated_stat) -> void:
	
	cont[_lored].fps[_updated_stat].set = true
