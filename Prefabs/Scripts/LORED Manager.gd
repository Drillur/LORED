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
	
	assignChildren(get_node("sc/v/1"))
	assignChildren(get_node("sc/v/2"))


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
