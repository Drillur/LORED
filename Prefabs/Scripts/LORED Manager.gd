extends MarginContainer



var src := {
	hbox = preload("res://Prefabs/template/HBoxContainer 10 separation.tscn"),
}

var cont := {}

var LOREDKeys: Array = lv.Type.keys()
#var g_keys = gv.g.keys()

func _ready():
	get_node("sc/v/3").hide()
	
	gv.connect("autobuyer_purchased", self, "autobuyer_purchased")
	gv.connect("manualLabor", self, "instanceManualLabor")
	
	for f in lv.lored:
		add_child(lv.lored[f])


func setup():
	
	setup_s1()
	return
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
	
	assignChildren(get_node("sc/v/1"))

func assignChildren(motherNode):
	for child in motherNode.get_children():
		if child.name in LOREDKeys:
			var type = lv.Type[child.name]
			cont[type] = child
			cont[type].hide()
			lv.lored[type].assignVico(child)
		if child.get_child_count() > 0:
			assignChildren(child)
	

func setup_s3():
	return
	var i = 0
	
	i += 1
	
	
	get_node("sc/v/3").move_child(get_node("sc/v/3/v"), get_node("sc/v/3").get_child_count())

func add_stuffs(key: String, i: int):
	
	cont[key] = gv.SRC["LORED"].instance()
	cont[key].setup(key)
	
	var stage = gv.g[key].stage
	
	if not "h" + stage + str(i) in cont.keys():
		cont["h" + stage + str(i)] = src.hbox.instance()
		get_node("sc/v/" + stage).add_child(cont["h" + stage + str(i)])
	
	cont["h" + stage + str(i)].add_child(cont[key])


func autobuyer_purchased(key):
	cont[key].r_autobuy()




func instanceManualLabor():
	var stinky = gv.SRC["manual labor"].instance()
	get_node("sc/v/1").add_child(stinky)
	gv.manualLaborActive = true
