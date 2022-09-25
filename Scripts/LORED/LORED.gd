class_name LORED
extends Reference




const saved_vars := ["purchased", "keyLORED", "asleep", "exporting", "timesPurchased", "level", "currentFuel"]

var manager: Node2D
func assignManager(_manager: Node2D):
	manager = _manager


var type: int
var tab: int
var stage: int
var level: int = 1
var timesPurchased := 0

var smart := false
var asleep := false
var exporting := true
var working := false # job in progress
var unlocked := false # a wish was completed that unlocked this lored
var purchased := false # purchased at least a single time in the current run

var name: String
var shorthandKey: String
var pronoun := ["he", "him", "his"]

var keyLORED := false

var color: Color

var icon: Texture



func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Ob.Num:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary) -> void:
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Ob.Num:
			get(x).load(data[x])
		else:
			set(x, str2var(data[x]))
	
	if not purchased:
		return
	
	#note load jobs above this. also, sync producedResources before this.
	unlockResources()
	
	if not gv.option["on_save_halt"]:
		asleep = false
	if not gv.option["on_save_hold"]:
		exporting = true 
	
	gv.list.lored["active " + str(tab)].append(type)
	
	if type != lv.Type.STONE:
		increaseCost(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, costModifier)
	
	for x in str2var(data["level"]) - 1:
		levelUp()


func _init(_type: int):
	type = _type
	
	var base_name: String = lv.Type.keys()[type]
	shorthandKey = base_name.to_lower()
	
	call("construct_" + base_name)
	
	name = base_name.capitalize().replace("_", " ")
	keyLORED = type in lv.DEFAULT_KEY_LOREDS
	tab = [gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, gv.Tab.S4][stage - 1]
	fuelResourceLORED = lv.Type.COAL if fuelResource == gv.Resource.COAL else lv.Type.JOULES
	fuelResourceShorthand = "coal" if fuelResource == gv.Resource.COAL else "jo"
	fuelStorageBits.changeBase(Big.new(fuelCostBits.base).m(jobs.values()[0].durationBits.base).m(40))
	setProducedResources()
	setUsedResources()
	if usedResources.size() > 0:
		var mod = 1.0
		for usedResourceCount in usedResources.size():
			mod *= 1.5
		fuelCostBits.changeBase(Big.new(0.09 * mod))
		
	if not fuelResource in gv.list["fuel resource"]:
		gv.list["fuel resource"].append(fuelResource)
	
	setupRefuelJob()
	
	syncAll()


func setupRefuelJob():
	refuelJob = Job.new(lv.Job.REFUEL, type)
	refuelJob.primaryResource = fuelResource
	refuelJob.primaryResourceIcon = gv.sprite[gv.shorthandByResource[fuelResource]]
	refuelJob.primaryResourceColor = gv.COLORS[gv.shorthandByResource[fuelResource]]


func construct_STONE():
	addJob(type)
	stage = 1
	addCost(gv.Resource.IRON, 25.0 / 3)
	addCost(gv.Resource.COPPER, 15 / 3)
	color = Color(0.79, 0.79, 0.79)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/stone.png")
func construct_COAL():
	addJob(type)
	stage = 1
	addCost(gv.Resource.STONE, 5)
	color = Color(0.7, 0, 1)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/coal.png")
func construct_IRON_ORE():
	addJob(type)
	stage = 1
	shorthandKey = "irono"
	addCost(gv.Resource.STONE, 8)
	color = Color(0, 0.517647, 0.905882)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/irono.png")
func construct_COPPER_ORE():
	addJob(type)
	stage = 1
	shorthandKey = "copo"
	addCost(gv.Resource.STONE, 8)
	color = Color(0.7, 0.33, 0)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/copo.png")
func construct_IRON():
	addJob(type)
	stage = 1
	addCost(gv.Resource.STONE, 9)
	addCost(gv.Resource.COPPER, 8)
	color = Color(0.07, 0.89, 1)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/iron.png")
func construct_COPPER():
	addJob(type)
	stage = 1
	shorthandKey = "cop"
	addCost(gv.Resource.STONE, 9)
	addCost(gv.Resource.IRON, 8)
	color = Color(1, 0.74, 0.05)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/cop.png")
func construct_JOULES():
	addJob(type)
	stage = 1
	shorthandKey = "jo"
	addCost(gv.Resource.CONCRETE, 25)
	color = Color(1, 0.98, 0)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/jo.png")
func construct_CONCRETE():
	addJob(type)
	stage = 1
	shorthandKey = "conc"
	addCost(gv.Resource.IRON, 90)
	addCost(gv.Resource.COPPER, 150)
	color = Color(0.35, 0.35, 0.35)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/conc.png")
func construct_GROWTH():
	addJob(type)
	stage = 1
	addCost(gv.Resource.STONE, 900)
	color = Color(0.79, 1, 0.05)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/growth.png")
func construct_OIL():
	addJob(type)
	stage = 1
	addCost(gv.Resource.COPPER, 1.6)
	addCost(gv.Resource.CONCRETE, 250)
	color = Color(0.65, 0.3, 0.66)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/oil.png")
func construct_TARBALLS():
	addJob(type)
	stage = 1
	shorthandKey = "tar"
	addCost(gv.Resource.IRON, 350)
	addCost(gv.Resource.MALIGNANCY, 10)
	color = Color(0.56, 0.44, 1)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/tar.png")
func construct_MALIGNANCY():
	addJob(type)
	stage = 1
	shorthandKey = "malig"
	addCost(gv.Resource.IRON, 900)
	addCost(gv.Resource.COPPER, 900)
	addCost(gv.Resource.CONCRETE, 50)
	color = Color(0.88, 0.12, 0.35)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/malig.png")
func construct_WATER():
	addJob(type)
	stage = 2
	shorthandKey = "water"
	addCost(gv.Resource.STONE, 2500)
	addCost(gv.Resource.WOOD, 80)
	color = Color(0, 0.647059, 1)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/water.png")
func construct_HUMUS():
	addJob(type)
	stage = 2
	addCost(gv.Resource.IRON, 600)
	addCost(gv.Resource.COPPER, 600)
	addCost(gv.Resource.GLASS, 30)
	color = Color(0.458824, 0.25098, 0)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/humus.png")
func construct_SOIL():
	addJob(type)
	stage = 2
	addCost(gv.Resource.CONCRETE, 1000)
	addCost(gv.Resource.HARDWOOD, 40)
	color = Color(0.737255, 0.447059, 0)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/soil.png")
func construct_TREES():
	addJob(type)
	stage = 2
	shorthandKey = "tree"
	addCost(gv.Resource.GROWTH, 150)
	addCost(gv.Resource.SOIL, 25)
	color = Color(0.772549, 1, 0.247059)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/tree.png")
func construct_SEEDS():
	addJob(type)
	stage = 2
	shorthandKey = "seed"
	addCost(gv.Resource.COPPER, 800)
	addCost(gv.Resource.TREES, 2)
	color = Color(1, 0.878431, 0.431373)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/seed.png")
func construct_GALENA():
	addJob(type)
	stage = 2
	shorthandKey = "gale"
	addCost(gv.Resource.STONE, 1100)
	addCost(gv.Resource.WIRE, 200)
	color = Color(0.701961, 0.792157, 0.929412)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/gale.png")
func construct_LEAD():
	addJob(type)
	stage = 2
	addCost(gv.Resource.STONE, 400)
	addCost(gv.Resource.GROWTH, 800)
	color = Color(0.53833, 0.714293, 0.984375)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/lead.png")
func construct_WOOD_PULP():
	addJob(type)
	stage = 2
	shorthandKey = "pulp"
	addCost(gv.Resource.WIRE, 15)
	addCost(gv.Resource.GLASS, 30)
	color = Color(0.94902, 0.823529, 0.54902)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/pulp.png")
func construct_PAPER():
	addJob(type)
	stage = 2
	addCost(gv.Resource.CONCRETE, 1200)
	addCost(gv.Resource.STEEL, 15)
	color = Color(0.792157, 0.792157, 0.792157)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/paper.png")
func construct_TOBACCO():
	addJob(type)
	stage = 2
	shorthandKey = "toba"
	addCost(gv.Resource.SOIL, 3)
	addCost(gv.Resource.HARDWOOD, 15)
	color = Color(0.639216, 0.454902, 0.235294)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/toba.png")
func construct_CIGARETTES():
	addJob(type)
	stage = 2
	shorthandKey = "ciga"
	addCost(gv.Resource.HARDWOOD, 50)
	addCost(gv.Resource.WIRE, 120)
	color = Color(0.929412, 0.584314, 0.298039)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/ciga.png")
func construct_PETROLEUM():
	addJob(type)
	stage = 2
	shorthandKey = "pet"
	addCost(gv.Resource.IRON, 3000)
	addCost(gv.Resource.COPPER, 4000)
	addCost(gv.Resource.GLASS, 130)
	color = Color(0.76, 0.53, 0.14)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/pet.png")
func construct_PLASTIC():
	addJob(type)
	stage = 2
	shorthandKey = "plast"
	addCost(gv.Resource.STONE, 10000)
	addCost(gv.Resource.TARBALLS, 700)
	color = Color(0.85, 0.85, 0.85)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/plast.png")
func construct_CARCINOGENS():
	addJob(type)
	stage = 2
	shorthandKey = "carc"
	addCost(gv.Resource.GROWTH, 8500)
	addCost(gv.Resource.CONCRETE, 2000)
	addCost(gv.Resource.STEEL, 150)
	addCost(gv.Resource.LEAD, 800)
	color = Color(0.772549, 0.223529, 0.192157)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/carc.png")
func construct_LIQUID_IRON():
	addJob(type)
	stage = 2
	shorthandKey = "liq"
	addCost(gv.Resource.CONCRETE, 900)
	addCost(gv.Resource.STEEL, 25)
	color = Color(0.27, 0.888, .9)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/liq.png")
func construct_STEEL():
	addJob(type)
	stage = 2
	addCost(gv.Resource.IRON, 15000)
	addCost(gv.Resource.COPPER, 3000)
	addCost(gv.Resource.HARDWOOD, 35)
	color = Color(0.607843, 0.802328, 0.878431)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/steel.png")
func construct_SAND():
	addJob(type)
	stage = 2
	addCost(gv.Resource.IRON, 700)
	addCost(gv.Resource.COPPER, 2850)
	color = Color(.87, .70, .45)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/sand.png")
	pronoun = ["she", "her", "hers"]
func construct_GLASS():
	addJob(type)
	stage = 2
	addCost(gv.Resource.COPPER, 6000)
	addCost(gv.Resource.STEEL, 40)
	color = Color(0.81, 0.93, 1.0)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/glass.png")
func construct_WIRE():
	addJob(type)
	stage = 2
	addCost(gv.Resource.STONE, 13000)
	addCost(gv.Resource.GLASS, 30)
	color = Color(0.9, 0.6, 0.14)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/wire.png")
	pronoun = ["she", "her", "hers"]
func construct_DRAW_PLATE():
	addJob(type)
	stage = 2
	shorthandKey = "draw"
	addCost(gv.Resource.IRON, 900)
	addCost(gv.Resource.CONCRETE, 300)
	addCost(gv.Resource.WIRE, 20)
	color = Color(0.333333, 0.639216, 0.811765)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/draw.png")
func construct_AXES():
	addJob(type)
	stage = 2
	shorthandKey = "axe"
	addCost(gv.Resource.IRON, 1000)
	addCost(gv.Resource.HARDWOOD, 55)
	color = Color(0.691406, 0.646158, 0.586075)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/axe.png")
func construct_WOOD():
	addJob(type)
	stage = 2
	addCost(gv.Resource.COPPER, 4500)
	addCost(gv.Resource.WIRE, 15)
	color = Color(0.545098, 0.372549, 0.015686)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/wood.png")
func construct_HARDWOOD():
	addJob(type)
	stage = 2
	shorthandKey = "hard"
	addCost(gv.Resource.IRON, 3500)
	addCost(gv.Resource.CONCRETE, 350)
	addCost(gv.Resource.WIRE, 35)
	color = Color(0.92549, 0.690196, 0.184314)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/hard.png")
	pronoun = ["she", "her", "hers"]
func construct_TUMORS():
	addJob(type)
	stage = 2
	shorthandKey = "tum"
	addCost(gv.Resource.HARDWOOD, 50)
	addCost(gv.Resource.WIRE, 150)
	addCost(gv.Resource.GLASS, 150)
	addCost(gv.Resource.STEEL, 100)
	color = Color(1, .54, .54)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/tum.png")




func syncAll():
	queue(lv.Queue.OUTPUT)
	queue(lv.Queue.INPUT)
	queue(lv.Queue.COST)
	queue(lv.Queue.FUEL_COST)
	queue(lv.Queue.FUEL_STORAGE)
	queue(lv.Queue.CRIT)
	queue(lv.Queue.HASTE)

var queue: Array
func queue(that: int):
	if queue.has(that):
		return
	queue.append(that)




# - - - Output

var output: Big
var outputText: String setget , getOutputText
var outputBits := Bits.new({
	lv.Num.BASE: 1.0,
	lv.Num.ADD: {
		lv.Num.FROM_UPGRADES: Big.new(0),
	},
	lv.Num.MULTIPLY: {
		lv.Num.FROM_LEVELS: Big.new(1),
		lv.Num.FROM_UPGRADES: Big.new(1),
		lv.Num.BY_LIMIT_BREAK: Big.new(1),
	},
})

func syncOutput():
	output = outputBits.total
	syncJobs_producedResources()

func getOutputText() -> String:
	return outputBits.totalText

func increaseOutput(folder: int, item: int, amount):
	outputBits.multiplyValue(folder, item, amount)
	queue(lv.Queue.OUTPUT)
func setOutputValue(folder: int, item: int, amount):
	outputBits.setValue(folder, item, amount)
	queue(lv.Queue.OUTPUT)
var producedResources: Array
func setProducedResources():
	for j in jobs:
		var poop = jobs[j].producedResources.keys()
		for p in poop:
			producedResources.append(p)



# - - - Input

var input: Big
var inputText: String setget , getInputText
var inputBits := Bits.new({
	lv.Num.BASE: 1.0,
	lv.Num.ADD: {
		lv.Num.FROM_UPGRADES: Big.new(0),
	},
	lv.Num.MULTIPLY: {
		lv.Num.FROM_LEVELS: Big.new(1),
		lv.Num.FROM_UPGRADES: Big.new(1),
	},
})

func syncInput():
	input = inputBits.total
	syncJobs_requiredResources()

func getInputText() -> String:
	return inputBits.totalText

func increaseInput(folder: int, item: int, amount):
	inputBits.multiplyValue(folder, item, amount)
	queue(lv.Queue.INPUT)


var usedResources: Array
var usedBy: Array
func setUsedResources():
	for j in jobs:
		var poop = jobs[j].requiredResourcesBits.keys()
		for p in poop:
			usedResources.append(p)



# - - - Cost

var cost := {}
var costText: Dictionary setget , getCostText
var costBits := {}
var costBitsUpdated := false
var costModifier := 3.0
var baseCost := {}
func addCost(key: int, base: float):
	baseCost[key] = base
	costBits[key] = Bits.new({
		lv.Num.BASE: base,
		lv.Num.DIVIDE: {
			lv.Num.FROM_UPGRADES: Big.new(1),
		},
		lv.Num.MULTIPLY: {
			lv.Num.FROM_LEVELS: Big.new(1),
		},
	})
func removeCost(key: int):
	if not key in cost.keys():
		return
	costBits.erase(key)
	cost.erase(key)
func syncCost():
	for c in costBits:
		cost[c] = costBits[c].total
	costBitsUpdated = true

func getCostText() -> Dictionary:
	if costBitsUpdated:
		costBitsUpdated = false
		costText = {}
		for c in costBits:
			costText[c] = costBits[c].totalText
	return costText

func takeawayCost():
	for c in cost:
		gv.subtractFromResource(c, cost[c])
func increaseCost(folder: int, item: int, amount):
	for c in costBits:
		costBits[c].multiplyValue(folder, item, amount)
	queue(lv.Queue.COST)

func syncCostModifier():
	costModifier = 3.0
	if gv.up["upgrade_name"].active():
		if stage == 1 and fuelResource == gv.Resource.COAL:
			costModifier = 2.75
	if gv.up["upgrade_description"].active():
		costModifier *= 0.9



# - - - Fuel Cost

var fuelCost: Big
var fuelCostText: String setget , getFuelCostText
var fuelResource: int
var fuelResourceLORED: int
var fuelResourceShorthand: String
var fuelCostBits := Bits.new({
	lv.Num.BASE: 0.09,
	lv.Num.MULTIPLY: {
		lv.Num.FROM_LEVELS: Big.new(1),
		lv.Num.FROM_UPGRADES: Big.new(1),
	},
})

func syncFuelCost():
	fuelCost = fuelCostBits.total

func getFuelCostText() -> String:
	return fuelCostBits.totalText

func increaseFuelCost(folder: int, item: int, amount):
	fuelCostBits.multiplyValue(folder, item, amount)
	queue(lv.Queue.FUEL_COST)



# - - - Fuel Storage

var fuelStorage: Big
var fuelStorageText: String setget , getFuelStorageText
var currentFuel := Big.new(0)
var currentFuelText: String setget , getCurrentFuelText
var fuelStorageBits := Bits.new({
	lv.Num.BASE: 1.0,
	lv.Num.MULTIPLY: {
		lv.Num.FROM_LEVELS: Big.new(1),
		lv.Num.FROM_UPGRADES: Big.new(1),
	},
})

func syncFuelStorage():
	fuelStorage = fuelStorageBits.total

func getFuelStorageText() -> String:
	return fuelStorageBits.totalText
func getCurrentFuelText() -> String:
	return currentFuel.toString()

var currentFuelPercent setget , getCurrentFuelPercent
func getCurrentFuelPercent() -> float:
	return currentFuel.percent(fuelStorage)

func increaseFuelStorage(folder: int, item: int, amount):
	fuelStorageBits.multiplyValue(folder, item, amount)
	queue(lv.Queue.FUEL_STORAGE)



# - - - Crit

var crit: float
var critText: String setget , getCritText
var critBits := BitsFloat.new({
	lv.Num.BASE: 0.0,
	lv.Num.ADD: {
		lv.Num.FROM_UPGRADES: 0.0,
	},
	lv.Num.MULTIPLY: {
		lv.Num.FROM_UPGRADES: 1.0,
	},
})

func syncCrit():
	crit = critBits.total

func getCritText() -> String:
	return critBits.totalText + "%"

func increaseCrit(folder: int, item: int, amount):
	critBits.multiplyValue(folder, item, amount)
	queue(lv.Queue.CRIT)



# - - - Haste

var haste: float
var baseHaste: float setget , getBaseHaste
var hasteText: String setget , getHasteText
var hasteBits := BitsFloat.new({
	lv.Num.BASE: 1.0,
	lv.Num.MULTIPLY: {
		lv.Num.FROM_UPGRADES: 1.0,
		lv.Num.BY_LIMIT_BREAK: 1.0,
	},
})

func syncHaste():
	haste = hasteBits.total
	syncJobs_duration()

func getHasteText() -> String:
	return hasteBits.totalText

func setHasteValue(folder: int, item: int, amount):
	hasteBits.setValue(folder, item, amount)
	queue(lv.Queue.HASTE)

func getBaseHaste() -> float:
	return hasteBits.base



# - - - Jobs

var jobs: Dictionary
var refuelJob: Job
func addJob(jobType: int):
	jobs[jobType] = Job.new(jobType, type)
	if unlocked:
		for r in jobs[jobType].producedResources:
			if r in gv.list["unlocked resources"]:
				continue
			gv.list["unlocked resources"].append(r)
func syncJobs_all():
	refuelJob.syncAll()
	for job in jobs:
		jobs[job].syncAll()
func syncJobs_duration():
	refuelJob.syncDuration()
	for job in jobs:
		jobs[job].syncDuration()
func syncJobs_producedResources():
	for job in jobs:
		jobs[job].syncProducedResources()
func syncJobs_requiredResources():
	for job in jobs:
		jobs[job].syncRequiredResources()

func getJobDuration(index: int) -> float:
	return jobs.values()[index].duration



# - - - Level Up!

func prePurchase():
	
	timesPurchased += 1
	
	takeawayCost()
	
	taq.increaseProgress(gv.Objective.LORED_UPGRADED, str(type))

func purchased():
	
	if not type in gv.list.lored["active " + str(tab)]:
		gv.list.lored["active " + str(tab)].append(type)
	
	if not purchased:
		firstPurchaseOfTheRun()
		return
	
	levelUp()
	var tenPercentFuel = Big.new(fuelStorage).d(10)
	if currentFuel.less(tenPercentFuel):
		currentFuel = tenPercentFuel

func levelUp():
	
	level += 1
	
	increaseCost(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, costModifier)
	
	increaseOutput(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, 2)
	increaseInput(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, 2)
	increaseFuelCost(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, 2)
	increaseFuelStorage(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, 2)

func firstPurchaseOfTheRun():
	
	purchased = true
	
	increaseCost(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, costModifier)
	
	if type != lv.Type.STONE:
		setFuelToMax()
	else:
		if gv.run1 > 1:
			setFuelToMax()
	
	manager.enterActive()
	
	if type in gv.list.lored["unlocked and inactive"]:
		gv.list.lored["unlocked and inactive"].erase(type)
	
	gv.list.lored["active"].append(type)
	
	if not gv.s2_upgrades_may_be_autobought:
		if type in gv.loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
			gv.check_for_the_s2_shit()
func setFuelToMax():
	currentFuel = Big.new(fuelStorage)

func unlockResources():
	for r in producedResources:
		if not r in gv.list["unlocked resources"]:
			gv.list["unlocked resources"].append(r)



# - - - Production

var lastJob := -1

func jobStarted(job: Job):
	if job.type == lastJob:
		if not queue.has(lv.Queue.UPDATE_PRODUCTION):
			return
	if queue.has(lv.Queue.UPDATE_PRODUCTION):
		queue.erase(lv.Queue.UPDATE_PRODUCTION)
	lastJob = job.type
	updateGain_working(job)
	updateDrain_working(job)

func updateGain_working(job: Job):
	if not job.producesResource:
		return
	var baseGainRate: Dictionary = job.gainRate
	for r in baseGainRate:
		lv.updateGain(r, type, baseGainRate[r])
func updateDrain_working(job: Job):
	if not job.requiresResource:
		return
	var baseDrainRate: Dictionary = job.drainRate
	for r in baseDrainRate:
		lv.updateDrain(r, type, baseDrainRate[r])


func finishedWorkingForNow():
	updateGain_zero(jobs[lastJob])
	updateDrain_zero(jobs[lastJob])
	lastJob = -1

func updateGain_zero(job: Job):
	if not job.producesResource:
		return
	for r in job.producedResources.keys():
		lv.updateGain(r, type, Big.new(0))
func updateDrain_zero(job: Job):
	if not job.requiresResource:
		return
	for r in job.requiredResources.keys():
		lv.updateDrain(r, type, Big.new(0))



#func getTotalJobTime() -> float:
#	var totalJobTime := 0.0
#	for j in jobs:
#		totalJobTime += jobs[j].duration
#	return totalJobTime
#
#func updateTotalProduction():
#
#	var totalJobTime := getTotalJobTime()
#
#	updateTotalGain(totalJobTime)
#	updateTotalDrain(totalJobTime)
#func _updateTotalGain(totalJobTime: float = 0.0):
#
#	if totalJobTime == 0.0:
#		totalJobTime = getTotalJobTime()
#
#	for j in jobs:
#
#		var baseGainRate: Dictionary = jobs[j].gainRate
#
#		# cases where gain is zero
#		if true:
#
#			if asleep or not purchased:
#				updateTotalGainToZero(baseGainRate.keys())
#				return
#
#			var tenPercentFuel = Big.new(fuelStorage).m(0.1)
#			if currentFuel.less(tenPercentFuel):
#
#				if gv.up["don't take candy from babies"].active():
#					if stage > 1 and lv.lored[fuelResourceLORED].level <= 5:
#						updateTotalGainToZero(baseGainRate.keys())
#						return
#
#				if not lv.lored[fuelResourceLORED].purchased:
#					updateTotalGainToZero(baseGainRate.keys())
#					return
#
#		for r in baseGainRate:
#
#			var critBonus = 1 + (crit / 10)
#			baseGainRate[r].m(critBonus)
#
#			var jobDurationRatio = jobs[j].duration / totalJobTime
#			baseGainRate[r].m(jobDurationRatio)
#
#			lv.updateGain(r, type, baseGainRate[r])
#func updateTotalGainToZero(resources: Array):
#	for r in resources:
#		lv.updateGain(r, type, Big.new(0))
#
#func updateTotalDrain(totalJobTime: float = 0.0):
#
#	if totalJobTime == 0.0:
#		totalJobTime = getTotalJobTime()
#
#	for j in jobs:
#
#		var baseDrainRate: Dictionary = jobs[j].drainRate
#
#		# cases where drain is zero
#		if true:
#
#			if asleep or not purchased:
#				updateTotalDrainToZero(baseDrainRate.keys())
#				return
#
#			var tenPercentFuel = Big.new(fuelStorage).m(0.1)
#			if currentFuel.less(tenPercentFuel):
#
#				if gv.up["don't take candy from babies"].active():
#					if stage > 1 and lv.lored[fuelResourceLORED].level <= 5:
#						updateTotalDrainToZero(baseDrainRate.keys())
#						return
#
#				if not lv.lored[fuelResourceLORED].purchased:
#					updateTotalDrainToZero(baseDrainRate.keys())
#					return
#
#		for r in baseDrainRate:
#
#			var jobDurationRatio = jobs[j].duration / totalJobTime
#			baseDrainRate[r].m(jobDurationRatio)
#
#			lv.updateDrain(r, type, baseDrainRate[r])
#
#	if working:
#		var fuelUsage: Big = Big.new(fuelCost).m(60)
#		lv.updateDrain(fuelResource, type, fuelUsage)
#	else:
#		lv.updateDrain(fuelResource, type, Big.new(0))
#func updateTotalDrainToZero(resources: Array):
#	for r in resources:
#		lv.updateDrain(r, type, Big.new(0))



# - - - Actions

func stopExport():
	for resource in producedResources:
		if not resource in gv.resourcesNotBeingExported:
			gv.resourcesNotBeingExported.append(resource)
func resumeExport():
	for resource in producedResources:
		if not resource in gv.resourcesNotBeingExported:
			gv.resourcesNotBeingExported.erase(resource)
