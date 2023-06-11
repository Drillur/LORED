extends MarginContainer


var lored: int


func setup(key: int):
	
	lored = key
	
	static_vals()
	
	updateStorage()
	if not lv.lored[lored].smart:
		basicLOREDupdateConsumption()

func static_vals():
	
	#var icon: Texture
	var color: Color
	var fuel_source = lv.lored[lored].fuelResource
	
	#icon = gv.sprite[fuel_source]
	color = gv.COLORS[fuel_source]
	
	if not lv.lored[lored].smart:
		get_node("basicLORED").show()
		#get_node("basicLORED/fuel resource/h/icon/Sprite").texture = icon
		#get_node("basicLORED/fuel resource/h/text").text = gvv.g[fuel_source].name
		get_node("basicLORED/consumption/h/icon/Sprite").self_modulate = color
		get_node("basicLORED/storage/h/Fuel Progress").setup(lored)
		get_node("basicLORED/storage/ct").modulate = color

func updateStorage():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		var maxSize = get_node("basicLORED/storage/ct").rect_size.x
		var fuelPercent = lv.lored[lored].currentFuel.percent(lv.lored[lored].fuelStorage)
		get_node("basicLORED/storage/ct/c").rect_size.x = min(fuelPercent * maxSize, maxSize)
		
		var currentFuel = lv.lored[lored].currentFuelText
		var maxFuel = lv.lored[lored].fuelStorageText
		get_node("basicLORED/storage/text").text = currentFuel + " / " + maxFuel
		
		t.start(gv.fps)
		yield(t, "timeout")
	
	t.queue_free()

func basicLOREDupdateConsumption():
	
	var t = Timer.new()
	add_child(t)
	
	var fuel_source = lv.lored[lored].fuelResourceShorthand
	var fuelResource = "[img=<16>]" + gv.sprite[fuel_source].get_path() + "[/img] " + gv.resourceName[fuel_source]
	
	while not is_queued_for_deletion():
		
		var consumptionText: String = lv.lored[lored].fuelCostText + " " + fuelResource + " /s"
		
		if not lv.lored[lored].fullFuel():
			consumptionText += " (x2)"
		
		get_node("basicLORED/consumption/text").bbcode_text = "[center]" + consumptionText
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()
