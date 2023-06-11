extends MarginContainer

var lored: int
var key: String

var updateMethod: String

func setup(_lored: int, alert: int):
	
	lored = _lored
	key = lv.AlertType.keys()[alert]
	
	updateMethod = "update" + key
	
	get_node("%" + key).show()
	if has_method("set_icon_" + key):
		call("set_icon_" + key)
	else:
		get_node("%icon").hide()
	
	yield(self, "ready")
	
	match alert:
		lv.AlertType.REQUIRED_RESOURCE_NOT_EXPORTING:
			
			get_node("%top text").text = "Resource Dependency"
			get_node("%sub_" + key).show()
			
			var blockedResource: int
			
			for resource in lv.lored[lored].usedResources:
				if gv.resource_is_locked(resource):
					blockedResource = resource
					break
			
			var icon = gv.sprite[gv.shorthandByResource[blockedResource]]
			get_node("%iconRequiredResource").texture = icon
			get_node("%iconRequiredResource/shadow").texture = get_node("%iconRequiredResource").texture
			
			get_node("%textRequiredResource").text = gv.resourceName[blockedResource]
		
		lv.AlertType.ASLEEP:
			get_node("%top text").text = "Asleep"
			get_node("%sub_" + key).show()
			rect_min_size.x = 244
			return
		
		lv.AlertType.LOW_FUEL:
			
			rect_min_size.x = 216
			var resourceColor = gv.COLORS[gv.shorthandByResource[lv.lored[lored].fuelResource]]
			get_node("%sub_" + key).show()
			
			get_node("%top text").text = "Low Fuel"
			get_node("%fuelResource").text = gv.resourceName[lv.lored[lored].fuelResource]
			get_node("%fuelResource").self_modulate = resourceColor
			get_node("%fuelCost").self_modulate = resourceColor
			get_node("%fuel").self_modulate = resourceColor
			
			get_node("%Fuel Progress").text.show()
			get_node("%Fuel Progress").setup(lored)
	
	updateLoop()

func updateLoop():
	
	var t: Timer = Timer.new()
	t.one_shot = true
	t.wait_time = 1
	add_child(t)
	
	while not is_queued_for_deletion():
		
		if has_method(updateMethod):
			call(updateMethod)
		
		t.start(2)
		yield(t, "timeout")
	
	t.queue_free()

func updateLOW_FUEL():
	
	var currentFuel = lv.lored[lored].currentFuelText
	var maxFuel = lv.lored[lored].fuelStorageText
	get_node("%fuel").text = currentFuel + " / " + maxFuel
	
	get_node("%fuelCost").text = lv.lored[lored].fuelCostText + "/s"


func set_icon_LOW_FUEL():
	get_node("%icon").set_icon(gv.sprite["fuel"])

func set_icon_ASLEEP():
	get_node("%icon").set_icon(gv.sprite["Halt"])

func set_icon_REQUIRED_RESOURCE_NOT_EXPORTING():
	get_node("%icon").set_icon(gv.sprite["Lock"])
