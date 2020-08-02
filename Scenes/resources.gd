extends MarginContainer



const TOP_KEYS := ["malig", "tum"]

var cont := {}
var src := {
	resource = preload("res://Prefabs/resource_bar_resource.tscn"),
}



func _ready() -> void:
	
	gv.connect("amount_updated", self, "update_resource")
	gv.connect("net_updated", self, "net")


func setup():
	
	for g in TOP_KEYS:
		cont[g] = src.resource.instance()
		cont[g].setup(g)
		cont[g].r_amount()
	
	get_node("s1").add_child(cont["malig"])
	get_node("s1").move_child(cont["malig"], 0)
	get_node("s2").add_child(cont["tum"])
	get_node("s2").move_child(cont["tum"], 0)



func net(key: String, net: Array):
	
	if key in TOP_KEYS:
		return
	
	# remove positive from list
	if net[0].isLargerThan(net[1]):
		if key in cont.keys():
			cont[key].queue_free()
			cont.erase(key)
			return
	
	# if already in list, update text
	if key in cont.keys():
		net[1].s(net[0])
		cont[key].r_net(net[1])
		return
	
	# if too many, don't add
	if get_node("s" + gv.g[key].type[1]).get_child_count() >= 7:
		return
	
	# if 0 net, don't add
	if Big.new(net[0]).s(net[1]).isEqualTo(0):
		return
	
	# if not *too* negative, don't add
	if net[1].isLessThan(Big.new(net[0])):
		return
	
	# don't add if negative due to halt
	if gv.g[key].halt:
		return
	
	# add to list!
	
	net[1].s(net[0])
	
	cont[key] = src.resource.instance()
	cont[key].setup(key)
	get_node("s" + gv.g[key].type[1]).add_child(cont[key])
	
	cont[key].r_net(net[1])


func update_resource(key):
	
	if not key in TOP_KEYS:
		return
	
	if not get_node("s" + gv.g[key].type[1]).visible:
		return
	
	
	cont[key].r_amount()

func switch_tabs(tab: String):
	
	for x in get_children():
		if tab in x.name:
			x.show()
		else:
			x.hide()
