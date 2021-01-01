extends MarginContainer



const TOP_KEYS := ["malig", "tum", "spirit"]

var cont := {}
var src := {
	resource = preload("res://Prefabs/resource_bar_resource.tscn"),
}



func _ready() -> void:
	
	gv.connect("amount_updated", self, "update_resource")
	gv.connect("net_updated", self, "net")


func setup():
	
	var i = 1
	for g in TOP_KEYS:
		cont[g] = src.resource.instance()
		cont[g].setup(g)
		cont[g].r_amount()
		
		var bla: String
		match i:
			1: bla = "malig"
			2: bla = "tum"
			3: bla = "spirit"
		
		get_node("s" + str(i)).add_child(cont[bla])
		get_node("s" + str(i)).move_child(cont[bla], 0)
		
		i += 1



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
	
	if key in gv.g.keys():
		if not get_node("s" + gv.g[key].type[1]).visible:
			return
	else:
		if not get_node("s3").visible:
			return
	
	
	cont[key].r_amount()

func switch_tabs(tab: String):
	
	for x in get_children():
		if tab in x.name:
			x.show()
		else:
			x.hide()
