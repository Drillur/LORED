extends MarginContainer


func setup(type: int, info: String):
	var data = str2var(info)
	var key = LogManager.Type.keys()[type]
	get_node("%" + key).show()
	get_node("%icon" + key).show()
	call("setup_" + key, data)

func setup_OFFLINE_EARNINGS(data: Dictionary):
	
	rect_min_size.y = 270
	
	get_node("%title").text = "Earnings Report"
	
	get_node("%timeOffline").text = gv.parse_time_float(data["time offline"])
	
	for r in data["resources"]:
		
		var resource = gv.SRC["earnings report/resource"].instance()
		var shorthand = gv.shorthandByResource[r]
		
		resource.get_node("%icon").texture = gv.sprite[shorthand]
		resource.get_node("%shadow").texture = resource.get_node("%icon").texture
		resource.get_node("%resource").text = gv.resourceName[r]
		resource.get_node("%resource").self_modulate = gv.COLORS[shorthand]
		get_node("%list_OFFLINE_EARNINGS").add_child(resource)
		
		var _yield = gv.SRC["labels/medium label"].instance()
		_yield.self_modulate = gv.COLORS[shorthand]
		_yield.text = data["resources"][r]
		_yield.align = Label.ALIGN_CENTER
		get_node("%list_OFFLINE_EARNINGS").add_child(_yield)
