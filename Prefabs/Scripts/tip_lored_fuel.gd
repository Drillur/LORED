extends MarginContainer


var lored_key: String


func setup(key: String):
	
	lored_key = key
	
	static_vals()
	
	updateStorage()
	if not gv.g[lored_key].smart:
		basicLOREDupdateConsumption()

func static_vals():
	
	var icon: Texture
	var color: Color
	var fuel_source = gv.g[lored_key].fuel_source
	
	icon = gv.sprite[fuel_source]
	color = gv.COLORS[fuel_source]
	
	if not gv.g[lored_key].smart:
		get_node("basicLORED").show()
		#get_node("basicLORED/fuel resource/h/icon/Sprite").texture = icon
		#get_node("basicLORED/fuel resource/h/text").text = gv.g[fuel_source].name
		get_node("basicLORED/consumption/h/icon/Sprite").self_modulate = color
		get_node("basicLORED/storage/h/Fuel Progress").setup(lored_key)
		get_node("basicLORED/storage/ct").modulate = color

func updateStorage():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		var maxSize = get_node("basicLORED/storage/ct").rect_size.x
		var fuelPercent = gv.g[lored_key].f.f.percent(gv.g[lored_key].f.t)
		get_node("basicLORED/storage/ct/c").rect_size.x = min(fuelPercent * maxSize, maxSize)
		
		var currentFuel = gv.g[lored_key].f.f.toString()
		var maxFuel = gv.g[lored_key].f.t.toString()
		get_node("basicLORED/storage/text").text = currentFuel + " / " + maxFuel
		
		t.start(gv.fps)
		yield(t, "timeout")
	
	t.queue_free()

func basicLOREDupdateConsumption():
	
	var t = Timer.new()
	add_child(t)
	
	var fuel_source = gv.g[lored_key].fuel_source
	var fuelResource = "[img=<16>]" + gv.sprite[fuel_source].get_path() + "[/img] " + gv.g[fuel_source].name
	
	while not is_queued_for_deletion():
		
		var drain = Big.new(gv.g[lored_key].fc.t)
		var consumptionText: String = drain.toString() + " " + fuelResource + " /s"
		
		if gv.g[lored_key].f.f.less(gv.g[lored_key].f.t):
			consumptionText += " (x2)"
		
		get_node("basicLORED/consumption/text").bbcode_text = "[center]" + consumptionText
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()
