extends MarginContainer



onready var fuelProgress = get_node("%Fuel Progress")
onready var loredIcon = get_node("%loredIcon")
onready var loredName = get_node("%loredName")
onready var loredLevel = get_node("%loredLevel")



var type: int

func setup(_type: int):
	
	type = _type
	
	yield(self, "ready")
	
	fuelProgress.get_node("%text").show()
	fuelProgress.setup(type)
	
	loredIcon.texture = lv.lored[type].icon
	loredIcon.get_node("shadow").texture = lv.lored[type].icon
	loredName.text = lv.lored[type].name
	
	loop()

func loop():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		update()
		if 1==1:
			updateSimple()
		else:
			pass
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()

func update():
	loredLevel.text = lv.lored[type].levelText

func updateSimple():
	
	var suffix = "Simple"
	get_node("%loredOutput" + suffix).text = lv.lored[type].outputText
	get_node("%loredInput" + suffix).text = lv.lored[type].inputText
	get_node("%loredHaste" + suffix).text = lv.lored[type].hasteText
	get_node("%loredCrit" + suffix).text = lv.lored[type].critText
	get_node("%loredFuelCost" + suffix).text = lv.lored[type].fuelCostText
	get_node("%loredFuelStorage" + suffix).text = lv.lored[type].fuelStorageText
	get_node("%loredCostModifier" + suffix).text = lv.lored[type].costModifierText + "x"
	get_node("%loredFuelResource" + suffix).text = lv.lored[type].fuelResourceText
	get_node("%loredFuelResource" + suffix).self_modulate = gv.COLORS[gv.shorthandByResource[lv.lored[type].fuelResource]]
