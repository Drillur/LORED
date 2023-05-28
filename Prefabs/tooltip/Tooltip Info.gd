extends MarginContainer



onready var fuelProgress = get_node("%Fuel Progress")
onready var loredIcon = get_node("%loredIcon")
onready var loredName = get_node("%loredName")
onready var loredLevel = get_node("%loredLevel")



var type: int

func setup(_type: int):
	
	type = _type
	
	yield(self, "ready")
	
	
	loredIcon.texture = lv.lored[type].icon
	loredIcon.get_node("shadow").texture = lv.lored[type].icon
	loredName.text = lv.lored[type].name
	
	if not "jobs" in taq.completed_wishes:
		get_node("%bot").hide()
	if gv.option["loredFuel"]:
		fuelProgress.hide()
	else:
		fuelProgress.get_node("%text").show()
		fuelProgress.setup(type)
	
	loop()

func loop():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		update()
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()

func update():
	
	loredLevel.text = lv.lored[type].levelText
	
	get_node("%loredOutputSimple").text = lv.lored[type].outputText
	get_node("%loredInputSimple").text = lv.lored[type].inputText
	get_node("%loredHasteSimple").text = lv.lored[type].hasteText
	get_node("%loredCritSimple").text = lv.lored[type].critText
	get_node("%loredFuelCostSimple").text = lv.lored[type].fuelCostText
	get_node("%loredFuelStorageSimple").text = lv.lored[type].fuelStorageText
	get_node("%loredCostModifierSimple").text = lv.lored[type].costModifierText + "x"
	get_node("%loredFuelResourceSimple").text = lv.lored[type].fuelResourceText
	get_node("%loredFuelResourceSimple").self_modulate = gv.COLORS[gv.shorthandByResource[lv.lored[type].fuelResource]]
