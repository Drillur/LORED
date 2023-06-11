extends MarginContainer



onready var net = get_node("%net")
onready var gain = get_node("%gain")
onready var drain = get_node("%drain")
onready var maxNet = get_node("%maxNet")
onready var lored_list = get_node("%VBoxContainer")

var resource: int

var loreds := {}



func setup(_resource: int):
	
	resource = _resource
	
	set_icon()
	set_colors()
	set_resource_name()
	
	yield(self, "ready")
	
	connect_net_updated()
	connect_gain_updated()
	connect_drain_updated()
	connect_maxNet_updated()
	
	setup_gain()
	setup_drain()
	
	sort_loreds()


func set_icon():
	get_node("%icon").texture = gv.sprite[gv.shorthandByResource[resource]]
	get_node("%icon/shadow").texture = get_node("%icon").texture


func set_colors():
	
	var color = gv.COLORS[gv.shorthandByResource[resource]]
	
	get_node("border").self_modulate = color
	get_node("%resource name").self_modulate = color


func set_resource_name():
	
	name = gv.resourceName[resource]
	get_node("%resource name").text = name


func connect_net_updated():
	lv.connect("net_updated", self, "update_net_text")
	update_net_text()


func connect_maxNet_updated():
	lv.connect("maxNet_updated", self, "update_maxNet_text")
	update_maxNet_text()


func connect_gain_updated():
	lv.connect("gain_updated", self, "update_gain_text")
	update_gain_text()


func connect_drain_updated():
	lv.connect("drain_updated", self, "update_drain_text")
	update_drain_text()



func update_net_text(_resource: int = resource):
	if not _resource == resource:
		return
	net.text = lv.netText(resource) + "/s"


func update_maxNet_text(_resource: int = resource):
	if not _resource == resource:
		return
	maxNet.text = lv.maxNetText(resource) + "/s"


func update_gain_text(_resource: int = resource):
	if not _resource == resource:
		return
	gain.text = lv.gainRate(resource).toString() + "/s"


func update_drain_text(_resource: int = resource):
	if not _resource == resource:
		return
	drain.text = lv.drainRate(resource).toString() + "/s"



func setup_gain():
	
	var bits_keys = lv.gainBits[resource].get_bits()[lv.Num.ADD].keys()
	
	for lored in bits_keys:
		
		if lored in loreds.keys():
			loreds[lored].update_gain(resource, lored, lv.gainBits[resource].get_bits()[lv.Num.ADD])
			continue
		
		loreds[lored] = gv.SRC["WalletResourceTooltipLORED"].instance()
		loreds[lored].setup(resource, lored)
		lored_list.add_child(loreds[lored])



func setup_drain():
	
	var bits = lv.drainBits[resource].get_bits()
	
	for num in bits.keys():
		
		if bits[num].empty():
			continue
		
		for lored in bits[num]:
			
			if bits[num][lored].equal(0):
				continue
			
			if lored in loreds.keys():
				loreds[lored].update_drain(resource, lored, lv.drainBits[resource].get_bits())
				continue
			
			loreds[lored] = gv.SRC["WalletResourceTooltipLORED"].instance()
			loreds[lored].setup(resource, lored)
			lored_list.add_child(loreds[lored])



func sort_loreds():
	
	var parent = lored_list
	var sorted_nodes: Array = parent.get_children()
	
	sorted_nodes.sort_custom(self, "sort")
	
	for node in parent.get_children():
		parent.remove_child(node)
	
	for node in sorted_nodes:
		parent.add_child(node)

static func sort(a: Node, b: Node):
	return a.combined_amount.greater_equal(b.combined_amount)
	#return a.name.naturalnocasecmp_to(b.name) < 0
	
