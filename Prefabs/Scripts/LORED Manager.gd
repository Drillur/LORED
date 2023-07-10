extends MarginContainer



onready var scroll_container: ScrollContainer = $"%sc"

var src := {
	hbox = preload("res://Prefabs/template/HBoxContainer 10 separation.tscn"),
}

var cont := {}

var LOREDKeys: Array = lv.Type.keys()



func _ready():
	#get_node("%3").hide()
	
	gv.connect("autobuyer_purchased", self, "autobuyer_purchased")
	gv.connect("manualLabor", self, "instanceManualLabor")
	
	for f in lv.lored:
		add_child(lv.lored[f])



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shift"):
		scroll_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if Input.is_action_just_released("Shift"):
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP



func setup():
	
	assignChildren(get_node("%1"))
	assignChildren(get_node("%2"))
	assignChildren(get_node("%3"))


func assignChildren(motherNode):
	for child in motherNode.get_children():
		if child.name in LOREDKeys:
			var type = lv.Type[child.name]
			cont[type] = child
			cont[type].hide()
			lv.lored[type].assignVico(child)
		if child.get_child_count() > 0:
			assignChildren(child)


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
	get_node("%1").add_child(stinky)
	gv.manualLaborActive = true

func switchTab(tab: String):
	for x in ["%1", "%2", "%3", "%4"]:
		if x == "%" + tab:
			get_node(x).show()
		else:
			get_node(x).hide()
