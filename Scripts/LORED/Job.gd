class_name Job
extends Reference



var locked := true
var resourcesUnlocked := false
var costs_fuel := true

var type: int
var lored: int

var name: String
var key: String
var vicoText: String setget , get_text
var animation: String
var lored_key: String

#var considerBabyhood := false


func _init(_type: int, _lored: int):
	
	type = _type
	lored = _lored
	
	key = lv.Job.keys()[type]
	lored_key = lv.Type.keys()[lored]
	
	animation = lv.Type.keys()[lored]
	
	call("construct_" + key)
	
	setPrimaryResource()
	addResourceProducers()

func addResourceProducers():
	for resource in producedResourcesBits.keys():
		gv.addResourceProducer(resource, lored)


func construct_SIFT_SEEDS():
	setDuration(8)
	setVicoText("Sifting for flower seeds.")
	addProducedResource(gv.Resource.FLOWER_SEED, 1)
	add_resource_range(gv.Resource.FLOWER_SEED, 3, true)
	addRequiredResource(gv.Resource.SEEDS, 100)
	name = "Sift Seeds"
	animation = "no"

func construct_PLANT_SEED():
	setDuration(5)
	setVicoText("Identifying and planting a flower.")
	addRequiredResource(gv.Resource.FLOWER_SEED, 1)
	name = "Plant Flower"
	animation = "no"

func construct_IDLE():
	setDuration(2.5 if gv.dev_mode else 10)
	setVicoText("{idle}")
	name = "Idle"
	animation = "no"
	costs_fuel = false

func construct_REFUEL():
	setDuration(4)
	setVicoText("Refueling!")
	name = "Refuel"

func construct_COAL():
	setDuration(3.25)
	addProducedResource(gv.Resource.COAL, 1)
	name = "Dig"
func construct_STONE():
	setDuration(2.5)
	addProducedResource(gv.Resource.STONE, 1)
	name = "Pick Up"
func construct_IRON_ORE():
	setDuration(4.0)
	addProducedResource(gv.Resource.IRON_ORE, 1)
	name = "Shoot"
func construct_COPPER_ORE():
	setDuration(4.0)
	addProducedResource(gv.Resource.COPPER_ORE, 1)
	name = "Mine"
func construct_IRON():
	setDuration(5.0)
	addProducedResource(gv.Resource.IRON, 1)
	addRequiredResource(gv.Resource.IRON_ORE, 1)
	name = "Toast"
func construct_COPPER():
	setDuration(5.0)
	addProducedResource(gv.Resource.COPPER, 1)
	addRequiredResource(gv.Resource.COPPER_ORE, 1)
	name = "Cook"
func construct_CONCRETE():
	setDuration(10.0)
	addProducedResource(gv.Resource.CONCRETE, 1)
	addRequiredResource(gv.Resource.STONE, 1)
	name = "Mash"
func construct_GROWTH():
	setDuration(6.5)
	addProducedResource(gv.Resource.GROWTH, 1)
	addRequiredResource(gv.Resource.IRON, 1)
	addRequiredResource(gv.Resource.COPPER, 1)
	name = "Pop"
func construct_JOULES():
	setDuration(8.25)
	addProducedResource(gv.Resource.JOULES, 1)
	addRequiredResource(gv.Resource.COAL, 1)
	name = "Redirect"
func construct_OIL():
	setDuration(0.5)
	addProducedResource(gv.Resource.OIL, 0.075)
	name = "Succ"
func construct_TARBALLS():
	setDuration(4)
	addProducedResource(gv.Resource.TARBALLS, 1)
	addRequiredResource(gv.Resource.OIL, 1)
	name = "Mutate"
func construct_MALIGNANCY():
	setDuration(5)
	addProducedResource(gv.Resource.MALIGNANCY, 1)
	addRequiredResource(gv.Resource.TARBALLS, 1)
	addRequiredResource(gv.Resource.GROWTH, 1)
	name = "Manifest"
func construct_WATER():
	setDuration(3.25)
	addProducedResource(gv.Resource.WATER, 1)
	name = "Splish-Splash"
func construct_HUMUS():
	setDuration(4.575)
	addProducedResource(gv.Resource.HUMUS, 1)
	addRequiredResource(gv.Resource.GROWTH, 0.5)
	addRequiredResource(gv.Resource.WATER, 1)
	name = "Shit"
func construct_TREES():
	setDuration(20)
	addProducedResource(gv.Resource.TREES, 1)
	addRequiredResource(gv.Resource.WATER, 6)
	addRequiredResource(gv.Resource.SEEDS, 1)
	name = "Grow"
func construct_SEEDS():
	setDuration(5)
	addProducedResource(gv.Resource.SEEDS, 1)
	addRequiredResource(gv.Resource.WATER, 1.5)
	name = "Pollenate"
func construct_SOIL():
	setDuration(5)
	addProducedResource(gv.Resource.SOIL, 1)
	addRequiredResource(gv.Resource.HUMUS, 1.5)
	name = "Pollenate"
func construct_AXES():
	setDuration(7)
	addProducedResource(gv.Resource.AXES, 1)
	addRequiredResource(gv.Resource.HARDWOOD, 0.8)
	addRequiredResource(gv.Resource.STEEL, 0.25)
	name = "Construct"
func construct_WOOD():
	setDuration(5)
	addProducedResource(gv.Resource.WOOD, 25)
	addRequiredResource(gv.Resource.AXES, 5) #note verify that this is correct
	addRequiredResource(gv.Resource.TREES, 1)
	name = "Obliterate"
func construct_HARDWOOD():
	setDuration(4.58333)
	addProducedResource(gv.Resource.HARDWOOD, 1)
	addRequiredResource(gv.Resource.WOOD, 2)
	addRequiredResource(gv.Resource.CONCRETE, 1)
	name = "Seduce"
func construct_LIQUID_IRON():
	setDuration(4)
	addProducedResource(gv.Resource.LIQUID_IRON, 1)
	addRequiredResource(gv.Resource.IRON, 10)
	name = "Stew"
func construct_STEEL():
	setDuration(13.3333333)
	addProducedResource(gv.Resource.STEEL, 1)
	addRequiredResource(gv.Resource.LIQUID_IRON, 8)
	name = "Smelt"
func construct_SAND():
	setDuration(4)
	addProducedResource(gv.Resource.SAND, 2.5)
	addRequiredResource(gv.Resource.HUMUS, 1.5)
	name = "Levitate"
func construct_GLASS():
	setDuration(5.825)
	addProducedResource(gv.Resource.GLASS, 1)
	addRequiredResource(gv.Resource.SAND, 6)
	name = "Glass"
func construct_DRAW_PLATE():
	setDuration(10)
	addProducedResource(gv.Resource.DRAW_PLATE, 1)
	addRequiredResource(gv.Resource.STEEL, 0.5)
	name = "Doodle"
func construct_WIRE():
	setDuration(5)
	addProducedResource(gv.Resource.WIRE, 1)
	addRequiredResource(gv.Resource.COPPER, 5)
	addRequiredResource(gv.Resource.DRAW_PLATE, 0.4)
	name = "Sew"
func construct_GALENA():
	setDuration(4)
	addProducedResource(gv.Resource.GALENA, 1)
	name = "Jackhammer"
func construct_LEAD():
	setDuration(5)
	addProducedResource(gv.Resource.LEAD, 1)
	addRequiredResource(gv.Resource.GALENA, 1)
	name = "Filter"
func construct_PETROLEUM():
	setDuration(5)
	addProducedResource(gv.Resource.PETROLEUM, 1)
	addRequiredResource(gv.Resource.OIL, 3)
	name = "Process"
func construct_WOOD_PULP():
	setDuration(6.66666666)
	addProducedResource(gv.Resource.WOOD_PULP, 5)
	addRequiredResource(gv.Resource.STONE, 10)
	addRequiredResource(gv.Resource.WOOD, 5)
	name = "Strip"
func construct_PAPER():
	setDuration(5.33333)
	addProducedResource(gv.Resource.PAPER, 1)
	addRequiredResource(gv.Resource.WOOD_PULP, 0.6)
	name = "Paperify"
func construct_PLASTIC():
	setDuration(6.25)
	addProducedResource(gv.Resource.PLASTIC, 1)
	addRequiredResource(gv.Resource.COAL, 5)
	addRequiredResource(gv.Resource.PETROLEUM, 1)
	name = "Pollute"
func construct_TOBACCO():
	setDuration(8.3333333)
	addProducedResource(gv.Resource.TOBACCO, 1)
	addRequiredResource(gv.Resource.WATER, 2)
	addRequiredResource(gv.Resource.SEEDS, 1)
	name = "Smoke"
func construct_CIGARETTES():
	setDuration(2.583333)
	addProducedResource(gv.Resource.CIGARETTES, 1)
	addRequiredResource(gv.Resource.TARBALLS, 4)
	addRequiredResource(gv.Resource.TOBACCO, 1)
	addRequiredResource(gv.Resource.PAPER, 0.25)
	name = "Smoke"
func construct_CARCINOGENS():
	setDuration(7.5)
	addProducedResource(gv.Resource.CARCINOGENS, 1)
	addRequiredResource(gv.Resource.MALIGNANCY, 3)
	addRequiredResource(gv.Resource.CIGARETTES, 6)
	addRequiredResource(gv.Resource.PLASTIC, 5)
	name = "Somehow Create"
func construct_TUMORS():
	setDuration(16.666666)
	addProducedResource(gv.Resource.TUMORS, 1)
	addRequiredResource(gv.Resource.GROWTH, 10)
	addRequiredResource(gv.Resource.MALIGNANCY, 5)
	addRequiredResource(gv.Resource.CARCINOGENS, 3)
	name = "Grow"

func setVicoText(text: String):
	vicoText = text


func syncAll():
	syncDuration()
	syncProducedResources()
	syncRequiredResources()




# - - - Duration

var duration: float
var durationText: String setget , getDurationText
var durationBits: BitsFloat
func setDuration(base: float):
	durationBits = BitsFloat.new({
		lv.Num.BASE: base,
		lv.Num.MULTIPLY: {
			lv.Num.FROM_UPGRADES: 1.0,
		},
		lv.Num.DIVIDE: {
			lv.Num.BY_LORED_HASTE: 1.0,
		}
	})
func getDurationText() -> String:
	return durationBits.totalText
func syncDuration():
	durationBits.setValue(lv.Num.DIVIDE, lv.Num.BY_LORED_HASTE, lv.lored[lored].haste)
	duration = durationBits.total
	updateGain = true
	updateRequiredFuel()
	updateRequiredFuelText()
func changeBaseDuration(val: float):
	durationBits.changeBase(val)



# - - - Produced Resources

var producesResource := false
var range_multiplier := {}
var round_range_multiplier := {}
var producedResources := {}
var producedResourcesText: Dictionary setget , getProducedResourcesText
var producedResourcesBits := {}
var producedResourcesBitsUpdated := false
func addProducedResource(_key: int, base: float):
	if not producesResource:
		producesResource = true
	
	producedResourcesBits[_key] = Bits.new({
		lv.Num.BASE: base,
		lv.Num.MULTIPLY: {
			lv.Num.FROM_UPGRADES: Big.new(1),
			lv.Num.BY_LORED_OUTPUT: Big.new(1),
		},
	})
func add_resource_range(resource: int, _range: float, _should_round: bool):
	range_multiplier[resource] = _range
	round_range_multiplier[resource] = _should_round

func syncProducedResources():
	for c in producedResourcesBits:
		producedResourcesBits[c].setValue(lv.Num.MULTIPLY, lv.Num.BY_LORED_OUTPUT, lv.lored[lored].output)
		producedResources[c] = producedResourcesBits[c].total
	producedResourcesBitsUpdated = true
	updateGain = true
	updateOfflineNet = true

func getProducedResourcesText() -> Dictionary:
	if producedResourcesBitsUpdated:
		producedResourcesBitsUpdated = false
		producedResourcesText = {}
		for c in producedResourcesBits:
			producedResourcesText[c] = producedResourcesBits[c].totalText
	return producedResourcesText



# - - - Required Resources

var requiresResource: bool
var requiredResources := {}
var requiredResourcesText: Dictionary setget , getRequiredResourcesText
var requiredResourcesBits := {}
var requiredResourcesBitsUpdated := false
func addRequiredResource(_key: int, base: float):
	if not requiresResource:
		requiresResource = true
	requiredResourcesBits[_key] = Bits.new({
		lv.Num.BASE: base,
		lv.Num.DIVIDE: {
			lv.Num.FROM_UPGRADES: Big.new(1),
		},
		lv.Num.MULTIPLY: {
			lv.Num.FROM_UPGRADES: Big.new(1),
			lv.Num.BY_LORED_INPUT: Big.new(1),
		},
	})
func syncRequiredResources():
	for c in requiredResourcesBits:
		requiredResourcesBits[c].setValue_inferValueByLOREDType(lv.Num.MULTIPLY, lored)
		requiredResources[c] = requiredResourcesBits[c].total
	requiredResourcesBitsUpdated = true
	updateDrain = true

func getRequiredResourcesText() -> Dictionary:
	if requiredResourcesBitsUpdated:
		requiredResourcesBitsUpdated = false
		requiredResourcesText = {}
		for c in requiredResourcesBits:
			requiredResourcesText[c] = requiredResourcesBits[c].totalText
	return requiredResourcesText

func getRequiredResource(resource: int) -> Big:
	return requiredResources[resource]



# - - - Required Fuel

var updateRequiredFuel := false
var updateRequiredFuelText := true
var requiredFuel: Big setget , getRequiredFuel
var requiredFuelText: String setget , getRequiredFuelText

func getRequiredFuel() -> Big:
	if updateRequiredFuel:
		setRequiredFuel()
	return requiredFuel
func setRequiredFuel():
	updateRequiredFuel = false
	if costs_fuel:
		requiredFuel = Big.new(lv.lored[lored].fuelCost).m(duration)
	else:
		requiredFuel = Big.new(0)
func updateRequiredFuel():
	if updateRequiredFuel:
		return
	updateRequiredFuel = true

func getRequiredFuelText() -> String:
	if updateRequiredFuelText:
		setRequiredFuelText()
	return requiredFuelText
func setRequiredFuelText():
	updateRequiredFuelText = false
	requiredFuelText = getRequiredFuel().toString()
func updateRequiredFuelText():
	if updateRequiredFuelText:
		return
	updateRequiredFuelText = true



# - - - Primary Resource

var primaryResource := -1
var primaryResourceIcon: Texture
var primaryResourceColor: Color
func setPrimaryResource():
	if not producesResource:
		return
	primaryResource = producedResourcesBits.keys()[0]
	primaryResourceIcon = gv.sprite[gv.shorthandByResource[primaryResource]]
	primaryResourceColor =  gv.COLORS[gv.shorthandByResource[primaryResource]]



# - - - Actions

func unlock():
	locked = false
	unlockResources()

func unlockResources():
	if resourcesUnlocked:
		return
	if canUnlockResources():
		resourcesUnlocked = true
		for resource in producedResourcesBits.keys():
			gv.unlockResource(resource)

func canUnlockResources() -> bool:
	
	if type == lv.Job.REFUEL or lored == lv.Type.COAL:
		return true
	
	if not lv.lored[lored].fuelResource in gv.list["unlocked resources"]:
		return false
	
	if requiredResourcesBits.size() == 0:
		return true
	
	for resource in requiredResourcesBits.keys():
		
		var atLeastOne := false
		
		for producer in gv.list["resource producer"][resource]:
			if lv.lored[producer].purchased:
				atLeastOne = true
				break
		
		if atLeastOne:
			return true
	
	return false

func randomize_duration():
	if type != lv.Job.IDLE:
		return
	durationBits.changeBase(rand_range(7.5, 12.5))
	syncDuration()


func remove_fuel_cost():
	costs_fuel = false



# - - - Handy

func eligibleForOfflineEarnings() -> bool:
	for resource in requiredResourcesBits.keys():
		if not gv.resourceBeingProduced(resource):
			return false
	return true

var reason_resource: int

func haveAndCanUseRequiredResources() -> bool:
	if requiresResource:
		for resource in requiredResources:
			if gv.resource_is_locked(resource):
				lv.lored[lored].reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LORED_NOT_EXPORTING
				reason_resource = resource
				return false
			if gv.resource[resource].less(requiredResources[resource]):
				lv.lored[lored].reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.INSUFFICIENT_RESOURCES
				reason_resource = resource
				return false
	return true




# - - - Production

var updateGain := true
var gainRate: Dictionary setget , getGain
func getGain() -> Dictionary:
	if not producesResource:
		return {}
	if updateGain:
		setGain()
	return gainRate
func setGain():
	updateGainText = true
	updateGain = false
	gainRate = {}
	var jobDurationRatio = duration / lv.lored[lored].totalJobTime
	for f in producedResources:
		gainRate[f] = Big.new(producedResources[f]).d(duration).m(jobDurationRatio)
	update_witch()

var updateGainText: bool
var gainText: Dictionary setget , getGainText
func getGainText() -> Dictionary:
	if updateGainText:
		setGainText()
	return gainText
func setGainText():
	updateGainText = false
	gainText = {}
	var gain = getGain()
	for f in gain:
		gainText[f] = gain[f].toString()

var updateDrain := true
var drainRate: Dictionary setget , getDrain
func getDrain() -> Dictionary:
	if updateDrain:
		setDrain()
	return drainRate
func setDrain():
	updateDrain = false
	drainRate = {}
	for f in requiredResources:
		drainRate[f] = Big.new(requiredResources[f]).d(duration)
		gv.producerDrainUpdated(f)


var updateOfflineNet := true
var offlineNet: Dictionary setget , getOfflineNet
func updateOfflineNet(resource: int):
	if resource in producedResources:
		updateOfflineNet = true
func getOfflineNet() -> Dictionary:
	if updateOfflineNet:
		setOfflineNet()
	return offlineNet
func setOfflineNet():
	
	#asdf
	updateOfflineNet = false
	
	var rawGain = getGain()
	offlineNet = {}
	
	var eligibleForOfflineEarnings := eligibleForOfflineEarnings()
	
	for resource in rawGain:
		
		if not eligibleForOfflineEarnings:
			offlineNet[resource] = [Big.new(0), 0]
			continue
		
		var _drainRate = Big.new(lv.drainRate(resource))
		
		var fuelRatio = 1
		var loredFuelResource = lv.lored[lored].getFuelResource()
		if lv.net(loredFuelResource)[1] == -1:
			fuelRatio = lv.gainRate(loredFuelResource).percent(lv.drainRate(loredFuelResource))
		
		var gain: Big = Big.new(rawGain[resource]).m(fuelRatio)
		
		if gain.greater_equal(_drainRate):
			gain.s(_drainRate)
			offlineNet[resource] = [gain, 1]
		else:
			_drainRate.s(gain)
			offlineNet[resource] = [_drainRate, -1]


func update_witch():
	
	if lv.lored[lored].buff_is_not_present(BuffManager.Type.WITCH):
		return
	
	lv.lored[lored].active_buffs[BuffManager.Type.WITCH].update_WITCH()


func add_pending_resource():
	for resource in producedResources.keys():
		gv.add_pending_resource(resource, lored, producedResources[resource])

func remove_pending_resource():
	for resource in producedResources.keys():
		gv.remove_pending_resource(resource, lored)



# - - - Vico Shit

func get_text() -> String:
	match type:
		lv.Job.IDLE:
			return get_idle_text()
	return vicoText


var idle_text_WITCH := []
var idle_text_BLOOD := []


func get_idle_text() -> String:
	var pool: Array = get("idle_text_" + lored_key)
	if pool.empty():
		call("setup_idle_text_" + lored_key)
		pool = get("idle_text_" + lored_key)
	var random_index: int = randi() % len(pool)
	return pool[random_index]


func setup_idle_text_BLOOD():
	idle_text_BLOOD = [
		"Patrolling Aurum.",
		"Studying Anthomancy.",
	]


func setup_idle_text_WITCH():
	idle_text_WITCH = [
		"Frolicking!",
		"Studying botany.",
		"Sculpting petals.",
		"Ignoring the bees!",
		"Kicking the gnomes!",
		"Juggling her potions.",
		"Smelling the flowers.",
		"Singing to the snails.",
		"Reading her tarot cards.",
		"Getting lost in the wood.",
		"Running away from her cat.",
		"Karaoke night with the deer!",
		"Having a picnic with some owls.",
		"Having a fashion show with mushrooms.",
		"Furiously watering all of the flowers at once!",
	]


func add_idle_text_WITCH():
	idle_text_WITCH.append("Brewing a bubble bath bomb!")
	idle_text_WITCH.append("Taste testing her curry potion!")
	idle_text_WITCH.append("Scratching her back with her wand.")
	idle_text_WITCH.append("Floating an acorn out of reach of a squirrel!")



func resource_has_a_range(resource: int) -> bool:
	return resource in range_multiplier.keys()


func should_round_random_value(resource: int) -> bool:
	return round_range_multiplier[resource]


var latest_random_value: float

func get_value_in_resource_range(resource: int) -> float:
	latest_random_value = rand_range(1, range_multiplier[resource])
	if should_round_random_value(resource):
		latest_random_value = round(latest_random_value)
	return latest_random_value



func completed():
	var complete_method = key + "_complete"
	if has_method(complete_method):
		call(complete_method)


func SIFT_SEEDS_complete():
	var roll_bonus := 0.0
	var count: int = lv.lored[lored].output.toInt()
	for seeds_picked_up in latest_random_value:
		Flower.store_new_flower_seed(count, roll_bonus)


func PLANT_SEED_complete():
	
	var flower_seed: FlowerSeed = Flower.get_most_recent_flower_seed()
	
	var count: int = flower_seed.count
	var flower_name = flower_seed.get_name()
	
	var crit_multiplier := 1.0
	var produced_resources := {flower_name: count}
	var output_text_details = Flower.get_output_text_details(produced_resources, crit_multiplier)
	lv.lored[lored].vico.throwOutputTexts(output_text_details)
	
	Flower.plant_flower_seed(flower_seed)

