class_name Job
extends Reference



var type: int
var lored: int

var canText: String
var actionText: String
#var considerBabyhood := false


func _init(_type: int, _lored: int):
	
	type = _type
	lored = _lored
	
	var base_name: String = lv.Job.keys()[type]
	
	call("construct_" + base_name)
	
	setPrimaryResource()
	#syncAll()

#func setup(stage: int):
#	if stage in [2, 3, 4]:
#		considerBabyhood = true

func construct_REFUEL():
	setDuration(4)
	setActionText("Refueling!")
	#canText = ""
func construct_COAL():
	setDuration(3.25)
	addProducedResource(gv.Resource.COAL, 1)
	canText = "Can dig for "
func construct_STONE():
	setDuration(2.5)
	addProducedResource(gv.Resource.STONE, 1)
	canText = "Can pick up "
func construct_IRON_ORE():
	setDuration(4.0)
	addProducedResource(gv.Resource.IRON_ORE, 1)
	canText = "Can shoot "
func construct_COPPER_ORE():
	setDuration(4.0)
	addProducedResource(gv.Resource.COPPER_ORE, 1)
	canText = "Can mine "
func construct_IRON():
	setDuration(5.0)
	addProducedResource(gv.Resource.IRON, 1)
	addRequiredResource(gv.Resource.IRON_ORE, 1)
	canText = " can toast "
func construct_COPPER():
	setDuration(5.0)
	addProducedResource(gv.Resource.COPPER, 1)
	addRequiredResource(gv.Resource.COPPER_ORE, 1)
	canText = " can cook "
func construct_CONCRETE():
	setDuration(10.0)
	addProducedResource(gv.Resource.CONCRETE, 1)
	addRequiredResource(gv.Resource.STONE, 1)
	canText = " can mash "
func construct_GROWTH():
	setDuration(6.5)
	addProducedResource(gv.Resource.GROWTH, 1)
	addRequiredResource(gv.Resource.IRON, 1)
	addRequiredResource(gv.Resource.COPPER, 1)
	canText = " can pinch off "
func construct_JOULES():
	setDuration(8.25)
	addProducedResource(gv.Resource.JOULES, 1)
	addRequiredResource(gv.Resource.COAL, 1)
	canText = " can redirect "
func construct_OIL():
	setDuration(0.5)
	addProducedResource(gv.Resource.OIL, 0.075)
	canText = "Can succ "
func construct_TARBALLS():
	setDuration(4)
	addProducedResource(gv.Resource.TARBALLS, 1)
	addRequiredResource(gv.Resource.OIL, 1)
	canText = " can mutate "
func construct_MALIGNANCY():
	setDuration(5)
	addProducedResource(gv.Resource.MALIGNANCY, 1)
	addRequiredResource(gv.Resource.TARBALLS, 1)
	addRequiredResource(gv.Resource.GROWTH, 1)
	canText = " can manifest "
func construct_WATER():
	setDuration(3.25)
	addProducedResource(gv.Resource.WATER, 1)
	canText = "Can splish-splash "
func construct_HUMUS():
	setDuration(4.575)
	addProducedResource(gv.Resource.HUMUS, 1)
	addRequiredResource(gv.Resource.GROWTH, 0.5)
	addRequiredResource(gv.Resource.WATER, 1)
	canText = " can shit "
func construct_TREES():
	setDuration(20)
	addProducedResource(gv.Resource.TREES, 1)
	addRequiredResource(gv.Resource.WATER, 6)
	addRequiredResource(gv.Resource.SEEDS, 1)
	canText = " can grow "
func construct_SEEDS():
	setDuration(5)
	addProducedResource(gv.Resource.SEEDS, 1)
	addRequiredResource(gv.Resource.WATER, 1.5)
	canText = " can pollenate "
func construct_SOIL():
	setDuration(5)
	addProducedResource(gv.Resource.SOIL, 1)
	addRequiredResource(gv.Resource.HUMUS, 1.5)
	canText = " can pollenate "
func construct_AXES():
	setDuration(7)
	addProducedResource(gv.Resource.AXES, 1)
	addRequiredResource(gv.Resource.HARDWOOD, 0.8)
	addRequiredResource(gv.Resource.STEEL, 0.25)
	canText = " can construct "
func construct_WOOD():
	setDuration(5)
	addProducedResource(gv.Resource.WOOD, 25)
	addRequiredResource(gv.Resource.AXES, 5) #note verify that this is correct
	addRequiredResource(gv.Resource.TREES, 1)
	canText = " can obliterate "
func construct_HARDWOOD():
	setDuration(4.58333)
	addProducedResource(gv.Resource.HARDWOOD, 1)
	addRequiredResource(gv.Resource.WOOD, 2)
	addRequiredResource(gv.Resource.CONCRETE, 1)
	canText = " can seduce "
func construct_LIQUID_IRON():
	setDuration(4)
	addProducedResource(gv.Resource.LIQUID_IRON, 1)
	addRequiredResource(gv.Resource.IRON, 10)
	canText = " can stew "
	setDuration(4.58333)
	addProducedResource(gv.Resource.HARDWOOD, 1)
	addRequiredResource(gv.Resource.WOOD, 2)
	addRequiredResource(gv.Resource.CONCRETE, 1)
	canText = " can seduce "
func construct_STEEL():
	setDuration(13.3333333)
	addProducedResource(gv.Resource.STEEL, 1)
	addRequiredResource(gv.Resource.LIQUID_IRON, 8)
	canText = " can smelt "
func construct_SAND():
	setDuration(4)
	addProducedResource(gv.Resource.SAND, 2.5)
	addRequiredResource(gv.Resource.HUMUS, 1.5)
	canText = " can not-force pull "
func construct_GLASS():
	setDuration(5.825)
	addProducedResource(gv.Resource.GLASS, 1)
	addRequiredResource(gv.Resource.SAND, 6)
	canText = " can glass "
func construct_DRAW_PLATE():
	setDuration(10)
	addProducedResource(gv.Resource.DRAW_PLATE, 1)
	addRequiredResource(gv.Resource.STEEL, 0.5)
	canText = " can doodle "
func construct_WIRE():
	setDuration(5)
	addProducedResource(gv.Resource.WIRE, 1)
	addRequiredResource(gv.Resource.COPPER, 5)
	addRequiredResource(gv.Resource.DRAW_PLATE, 0.4)
	canText = " can sew "
func construct_GALENA():
	setDuration(4)
	addProducedResource(gv.Resource.GALENA, 1)
	canText = "Can jackhammer "
func construct_LEAD():
	setDuration(5)
	addProducedResource(gv.Resource.LEAD, 1)
	addRequiredResource(gv.Resource.GALENA, 1)
	canText = " can filter "
func construct_PETROLEUM():
	setDuration(5)
	addProducedResource(gv.Resource.PETROLEUM, 1)
	addRequiredResource(gv.Resource.OIL, 3)
	canText = " can process "
func construct_WOOD_PULP():
	setDuration(6.66666666)
	addProducedResource(gv.Resource.WOOD_PULP, 5)
	addRequiredResource(gv.Resource.STONE, 10)
	addRequiredResource(gv.Resource.WOOD, 5)
	canText = " can strip "
func construct_PAPER():
	setDuration(5.33333)
	addProducedResource(gv.Resource.PAPER, 1)
	addRequiredResource(gv.Resource.WOOD_PULP, 0.6)
	canText = " can paperify "
func construct_PLASTIC():
	setDuration(6.25)
	addProducedResource(gv.Resource.PLASTIC, 1)
	addRequiredResource(gv.Resource.COAL, 5)
	addRequiredResource(gv.Resource.PETROLEUM, 1)
	canText = " can pollute "
func construct_TOBACCO():
	setDuration(8.3333333)
	addProducedResource(gv.Resource.TOBACCO, 1)
	addRequiredResource(gv.Resource.WATER, 2)
	addRequiredResource(gv.Resource.SEEDS, 1)
	canText = " can smoke "
func construct_CIGARETTES():
	setDuration(2.583333)
	addProducedResource(gv.Resource.CIGARETTES, 1)
	addRequiredResource(gv.Resource.TARBALLS, 4)
	addRequiredResource(gv.Resource.TOBACCO, 1)
	addRequiredResource(gv.Resource.PAPER, 0.25)
	canText = " can smoke "
func construct_CARCINOGENS():
	setDuration(7.5)
	addProducedResource(gv.Resource.CARCINOGENS, 1)
	addRequiredResource(gv.Resource.MALIGNANCY, 3)
	addRequiredResource(gv.Resource.CIGARETTES, 6)
	addRequiredResource(gv.Resource.PLASTIC, 5)
	canText = " can somehow make "
func construct_TUMORS():
	setDuration(16.666666)
	addProducedResource(gv.Resource.TUMORS, 1)
	addRequiredResource(gv.Resource.GROWTH, 10)
	addRequiredResource(gv.Resource.MALIGNANCY, 5)
	addRequiredResource(gv.Resource.CARCINOGENS, 3)
	canText = " can grow "



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



# - - - Produced Resources

var producesResource := false
var producedResources := {}
var producedResourcesText: Dictionary setget , getProducedResourcesText
var producedResourcesBits := {}
var producedResourcesBitsUpdated := false
func addProducedResource(key: int, base: float):
	if not producesResource:
		producesResource = true
	producedResourcesBits[key] = Bits.new({
		lv.Num.BASE: base,
		lv.Num.MULTIPLY: {
			lv.Num.FROM_UPGRADES: Big.new(1),
			lv.Num.BY_LORED_OUTPUT: Big.new(1),
		},
	})
func syncProducedResources():
	for c in producedResourcesBits:
		producedResourcesBits[c].setValue(lv.Num.MULTIPLY, lv.Num.BY_LORED_OUTPUT, lv.lored[lored].output)
		producedResources[c] = producedResourcesBits[c].total
	producedResourcesBitsUpdated = true
	updateGain = true

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
func addRequiredResource(key: int, base: float):
	if not requiresResource:
		requiresResource = true
	requiredResourcesBits[key] = Bits.new({
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
		requiredResourcesBits[c].setValue(lv.Num.MULTIPLY, lv.Num.BY_LORED_INPUT, lv.lored[lored].input)
		requiredResources[c] = requiredResourcesBits[c].total
	requiredResourcesBitsUpdated = true

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
func updateRequiredFuel():
	if updateRequiredFuel:
		return
	updateRequiredFuel = true

var requiredFuel: Big setget , getRequiredFuel
func getRequiredFuel() -> Big:
	if updateRequiredFuel:
		updateRequiredFuel = false
		setRequiredFuel()
	return requiredFuel
func setRequiredFuel():
	requiredFuel = Big.new(lv.lored[lored].fuelCost).m(duration)



# - - - Primary Resource

var primaryResource: int
var primaryResourceIcon: Texture
var primaryResourceColor: Color
func setPrimaryResource():
	if not producesResource:
		return
	primaryResource = producedResourcesBits.keys()[0]
	primaryResourceIcon = gv.sprite[gv.shorthandByResource[primaryResource]]
	primaryResourceColor =  gv.COLORS[gv.shorthandByResource[primaryResource]]


# - - - Handy

func haveAndCanUseRequiredResources() -> bool:
	if requiresResource:
		for resource in requiredResources:
			if gv.resource[resource].less(requiredResources[resource]):
				lv.lored[lored].reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.INSUFFICIENT_RESOURCES
				return false
			if resource in gv.resourcesNotBeingExported:
				lv.lored[lored].reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LORED_NOT_EXPORTING
				return false
	return true



# - - - Production

var updateGain := false
var gainRate: Dictionary setget , getGain
func getGain() -> Dictionary:
	if updateGain:
		setGain()
	return gainRate
func setGain():
	updateGain = false
	gainRate = {}
	for f in producedResources:
		gainRate[f] = Big.new(producedResources[f]).d(duration)

var updateDrain := false
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



func setActionText(text: String):
	actionText = text
