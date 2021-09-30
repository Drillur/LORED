extends MarginContainer



var src := {
	lored = preload("res://Prefabs/lored/LORED.tscn"),
	hbox = preload("res://Prefabs/template/HBoxContainer 10 separation.tscn"),
}

var cont := {}

var g_keys = gv.g.keys()

func _ready():
	get_node("sc/v/3").hide()
	
	gv.connect("autobuyer_purchased", self, "autobuyer_purchased")
	gv.connect("buff_spell_cast", self, "receive_buff")


func setup():
	
	setup_s1()
	setup_s2()
	setup_s3()

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

func setup_s1():
	
	var i = 0
	for x in gv.list.lored[gv.Tab.S1]:
		
		cont[x] = src.lored.instance()
		cont[x].setup(x)
		
		# add children
		if i % 2 == 0:
			cont["h1" + str(i)] = src.hbox.instance()
			get_node("sc/v/" + gv.g[x].type[1]).add_child(cont["h1" + str(i)])
			cont["h1" + str(i)].add_child(cont[x])
		else:
			cont["h1" + str(i - 1)].add_child(cont[x])
		
		i += 1
	
	cont["coal"].show()
	cont["stone"].show()

func setup_s3():
	return
	var i = 0
	
	i += 1
	
	
	get_node("sc/v/3").move_child(get_node("sc/v/3/v"), get_node("sc/v/3").get_child_count())

func add_stuffs(key: String, i: int):
	
	cont[key] = src.lored.instance()
	cont[key].setup(key)
	
	var stage = gv.g[key].stage
	
	if not "h" + stage + str(i) in cont.keys():
		cont["h" + stage + str(i)] = src.hbox.instance()
		get_node("sc/v/" + stage).add_child(cont["h" + stage + str(i)])
	
	cont["h" + stage + str(i)].add_child(cont[key])


func autobuyer_purchased(key):
	cont[key].r_autobuy()

func receive_buff(spell: String, target := "") -> void:
	
	pass


func saveLOREDs() -> String:
	
	var data := {}
	
	for x in gv.g:
		data[x] = gv.g[x].save()
	
	return var2str(data)

func loadLOREDs(data: Dictionary) -> void:
	for x in data:
		gv.g[x]._load(str2var(data[x]))
