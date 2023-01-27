extends MarginContainer


onready var bg = get_node("%bg")
onready var gnIcon = get_node("%icon")
onready var gnClose = get_node("%close")
onready var gnFuelRatio = get_node("%fuelRatio")
onready var gnFuelRatios = get_node("%fuel ratios")
onready var gnTimeOffline = get_node("%timeOffline")
onready var gnResourceProduction = get_node("%resourceProduction")

var unlockedResources: Array
var logDetails := {}


func setup(timeOffline: int):
	
	logDetails.clear()
	
	bg.self_modulate = SaveManager.save_file_color
	gnClose.modulate = SaveManager.save_file_color
	gnIcon.modulate = SaveManager.save_file_color
	
	unlockedResources = gv.list["unlocked resources"]
	
	if unlockedResources.size() < 6:
		return
	
	setupFuelRatios(timeOffline)
	setupResourceProduction(timeOffline)
	gnTimeOffline.text = "Time offline: " + gv.parse_time(timeOffline)
	
	show()


func setupFuelRatios(timeOffline: int):
	if shouldDisplayFuelRatios():
		gnFuelRatios.show()
		for resource in gv.list["fuel resource"]:
			if resource in unlockedResources:
				addFuelResource(resource, timeOffline)

func shouldDisplayFuelRatios() -> bool:
	for resource in gv.list["fuel resource"]:
		if resource in unlockedResources:
			var gain = lv.gainRate(resource)
			var drain = lv.drainRate(resource)
			if drain.greater(gain):
				return true
	return false

func addFuelResource(resource: int, timeOffline: int):
	
	var nameAndIconNodes = gv.SRC["earnings report/resource"].instance()
	
	var icon = gv.sprite[gv.shorthandByResource[resource]]
	nameAndIconNodes.get_node("%icon").texture = icon
	nameAndIconNodes.get_node("%shadow").texture = icon
	
	nameAndIconNodes.get_node("%resource").text = gv.resourceName[resource]
	
	gnFuelRatio.add_child(nameAndIconNodes)
	
	
	var gain = Big.new(lv.gainRate(resource)).m(timeOffline)
	var drain = Big.new(lv.drainRate(resource)).m(timeOffline)
	
	var fuelRatio = 1
	if drain.greater(gain):
		fuelRatio = gain.percent(drain)
		gain.m(fuelRatio)
	
	var gainNode = gv.SRC["labels/medium label"].instance()
	var drainNode = gv.SRC["labels/medium label"].instance()
	var ratioNode = gv.SRC["labels/medium label"].instance()
	gainNode.text = gain.toString()
	drainNode.text = drain.toString()
	ratioNode.text = fval.f(fuelRatio)
	
	gnFuelRatio.add_child(gainNode)
	gnFuelRatio.add_child(drainNode)
	gnFuelRatio.add_child(ratioNode)


func setupResourceProduction(timeOffline: int):
	for resource in unlockedResources:
		addResource(resource, timeOffline)

func addResource(resource: int, timeOffline: int):
	
	var nameAndIconNodes = gv.SRC["earnings report/resource"].instance()
	
	var icon = gv.sprite[gv.shorthandByResource[resource]]
	nameAndIconNodes.get_node("%icon").texture = icon
	nameAndIconNodes.get_node("%shadow").texture = icon
	
	nameAndIconNodes.get_node("%resource").text = gv.resourceName[resource]
	
	gnResourceProduction.add_child(nameAndIconNodes)
	
	
	var _yield: Big = Big.new(gv.offlineEarnings[resource][0])
	var _sign: int = gv.offlineEarnings[resource][1]
	
	var yieldText = "+"
	if _sign == 0:
		yieldText = ""
	elif _sign == -1:
		yieldText = "-"
	yieldText += _yield.toString()
	
	var yieldNode = gv.SRC["labels/medium label"].instance()
	yieldNode.text = yieldText
	
	gnResourceProduction.add_child(yieldNode)
	
	
	var gain = Big.new(lv.gainRate(resource)).m(timeOffline)
	var drain = Big.new(lv.drainRate(resource)).m(timeOffline)
	var gainNode = gv.SRC["labels/medium label"].instance()
	var drainNode = gv.SRC["labels/medium label"].instance()
	gainNode.text = gain.toString()
	drainNode.text = drain.toString()
	gnResourceProduction.add_child(gainNode)
	gnResourceProduction.add_child(drainNode)


func _on_close_pressed() -> void:
	close()

func close():
	hide()
