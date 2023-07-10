class_name LORED
extends Reference




const saved_vars := ["purchased", "timesPurchased", "level", "currentFuel"]


var manager: Node2D
func assignManager(_manager: Node2D):
	manager = _manager


var type: int
var tab: int
var stage: int
var level: int = 0
var timesPurchased := 0

var smart := false
var asleep := false
var working := false # job in progress
var keyLORED := false
var unlocked := false # a wish was completed that unlocked this lored
var purchased := false # purchased at least a single time in the current run

var key: String
var name: String
var shorthandKey: String

var emotePool: Array
var unlockedJobs: Array
var pronoun := ["he", "him", "his"]

var color: Color

var icon: Texture



func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary) -> void:
	
	#* Copy-paste this block to a script where saving a Dictionary is necessary
	var saved_vars_dict := {}
	
	for x in saved_vars:
		saved_vars_dict[x] = get(x)
	
	var loadedVars = SaveManager.loadSavedVars(saved_vars_dict, data)
	
	for x in saved_vars:
		if get(x) is Ob.Num or get(x) is Big:
			get(x).load(data[x])
		else:
			set(x, loadedVars[x])
	#*
	
	if not purchased:
		return
	
	jobs.values()[0].unlock()
	
	if purchased:
		gv.list.lored["active " + str(tab)].append(type)
		gv.list.lored["active"].append(type)
	
	levelUp(str2var(data["level"]))


func _init(_type: int):
	
	type = _type
	key = lv.Type.keys()[type]
	
	var base_name: String = lv.Type.keys()[type]
	shorthandKey = base_name.to_lower()
	name = base_name.capitalize().replace("_", " ")
	
	call("construct_" + base_name)
	
	if stage == 3:
		addJob(lv.Job.IDLE)
	
	keyLORED = type in lv.DEFAULT_KEY_LOREDS
	tab = [gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, gv.Tab.S4][stage - 1]
	fuelResourceLORED = lv.Type.COAL if fuelResource == gv.Resource.COAL else lv.Type.JOULES
	fuelResourceShorthand = "coal" if fuelResource == gv.Resource.COAL else "jo"
	if stage < 3:
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
	jobs[lv.Job.REFUEL] = Job.new(lv.Job.REFUEL, type)
	jobs[lv.Job.REFUEL].unlock()
	jobs[lv.Job.REFUEL].requiresResource = true
	jobs[lv.Job.REFUEL].requiredResourcesBits[fuelResource] = Bits.new({
		lv.Num.BASE: 0.25,
		lv.Num.MULTIPLY: {
			lv.Num.BY_LORED_FUEL_STORAGE: Big.new(fuelStorageBits.base),
		},
	})
	match type:
		lv.Type.OIL:
			jobs[lv.Job.REFUEL].changeBaseDuration(1)


func get_refuel_job() -> Job:
	return jobs[lv.Job.REFUEL]


func construct_BLOOD():
	name = "Charity"
	icon = preload("res://Sprites/reactions/WATER1.png")
	stage = 3
	color = gv.COLORS["BLOOD"]
	fuelResource = gv.Resource.COAL
	fuelStorageBits.changeBase(Big.new(25))
	set_pronouns(Gender.FEMALE)


func construct_WITCH():
	name = "Circe"
	icon = preload("res://Sprites/upgrades/thewitchofloredelith.png")
	stage = 3
	color = gv.COLORS["witch"]
	fuelResource = gv.Resource.COAL
	fuelStorageBits.changeBase(Big.new(25))
	set_pronouns(Gender.FEMALE)


func construct_STONE():
	addJob(type + 1)
	stage = 1
	addCost(gv.Resource.IRON, 25.0 / 3)
	addCost(gv.Resource.COPPER, 15 / 3)
	color = Color(0.79, 0.79, 0.79)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/stone.png")
	emotePool = [
		EmoteManager.Type.STONE0,
		EmoteManager.Type.STONE1,
		EmoteManager.Type.STONE2,
		EmoteManager.Type.STONE3,
		EmoteManager.Type.STONE4,
		EmoteManager.Type.STONE5,
		EmoteManager.Type.STONE6,
		EmoteManager.Type.STONE7,
	]
func construct_COAL():
	addJob(type + 1)
	stage = 1
	addCost(gv.Resource.STONE, 5)
	color = Color(0.7, 0, 1)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/coal.png")
	emotePool = [
		EmoteManager.Type.COAL0,
		EmoteManager.Type.COAL1,
		EmoteManager.Type.COAL2,
		EmoteManager.Type.COAL3,
		EmoteManager.Type.COAL4,
		EmoteManager.Type.COAL5,
		EmoteManager.Type.COAL6,
		EmoteManager.Type.COAL7,
	]
func construct_IRON_ORE():
	addJob(type + 1)
	stage = 1
	shorthandKey = "irono"
	addCost(gv.Resource.STONE, 8)
	color = Color(0, 0.517647, 0.905882)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/irono.png")
	emotePool = [
		EmoteManager.Type.IRON_ORE0,
		EmoteManager.Type.IRON_ORE1,
		EmoteManager.Type.IRON_ORE2,
		EmoteManager.Type.IRON_ORE3,
		EmoteManager.Type.IRON_ORE4,
		EmoteManager.Type.IRON_ORE5,
		EmoteManager.Type.IRON_ORE6,
		EmoteManager.Type.IRON_ORE7,
		EmoteManager.Type.IRON_ORE8,
		EmoteManager.Type.IRON_ORE9,
		EmoteManager.Type.IRON_ORE10,
	]
func construct_COPPER_ORE():
	addJob(type + 1)
	stage = 1
	shorthandKey = "copo"
	addCost(gv.Resource.STONE, 8)
	color = Color(0.7, 0.33, 0)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/copo.png")
	emotePool = [
		EmoteManager.Type.COPPER_ORE0,
		EmoteManager.Type.COPPER_ORE1,
		EmoteManager.Type.COPPER_ORE2,
		EmoteManager.Type.COPPER_ORE3,
		EmoteManager.Type.COPPER_ORE4,
		EmoteManager.Type.COPPER_ORE5,
		EmoteManager.Type.COPPER_ORE6,
		EmoteManager.Type.COPPER_ORE7,
		EmoteManager.Type.COPPER_ORE8,
		EmoteManager.Type.COPPER_ORE9,
		EmoteManager.Type.COPPER_ORE10,
		EmoteManager.Type.COPPER_ORE11,
		EmoteManager.Type.COPPER_ORE12,
	]
func construct_IRON():
	addJob(type + 1)
	stage = 1
	addCost(gv.Resource.STONE, 9)
	addCost(gv.Resource.COPPER, 8)
	color = Color(0.07, 0.89, 1)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/iron.png")
	emotePool = [
		EmoteManager.Type.IRON0,
		EmoteManager.Type.IRON1,
		EmoteManager.Type.IRON2,
		EmoteManager.Type.IRON4,
		EmoteManager.Type.IRON5,
		EmoteManager.Type.IRON6,
		EmoteManager.Type.IRON7,
	]
func construct_COPPER():
	addJob(type + 1)
	stage = 1
	shorthandKey = "cop"
	addCost(gv.Resource.STONE, 9)
	addCost(gv.Resource.IRON, 8)
	color = Color(1, 0.74, 0.05)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/cop.png")
	emotePool = [
		EmoteManager.Type.COPPER0,
		EmoteManager.Type.COPPER1,
		EmoteManager.Type.COPPER2,
		EmoteManager.Type.COPPER3,
		EmoteManager.Type.COPPER4,
		EmoteManager.Type.COPPER5,
		EmoteManager.Type.COPPER6,
		EmoteManager.Type.COPPER7,
	]
func construct_JOULES():
	addJob(type + 1)
	stage = 1
	shorthandKey = "jo"
	addCost(gv.Resource.CONCRETE, 25)
	color = Color(1, 0.98, 0)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/jo.png")
	emotePool = [
		EmoteManager.Type.JOULES0,
		EmoteManager.Type.JOULES1,
		EmoteManager.Type.JOULES2,
		EmoteManager.Type.JOULES3,
		EmoteManager.Type.JOULES4,
		EmoteManager.Type.JOULES5,
		EmoteManager.Type.JOULES6,
		EmoteManager.Type.JOULES7,
	]
func construct_CONCRETE():
	addJob(type + 1)
	stage = 1
	shorthandKey = "conc"
	addCost(gv.Resource.IRON, 90)
	addCost(gv.Resource.COPPER, 150)
	color = Color(0.35, 0.35, 0.35)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/conc.png")
	emotePool = [
		EmoteManager.Type.CONCRETE0,
		EmoteManager.Type.CONCRETE1,
		EmoteManager.Type.CONCRETE2,
		EmoteManager.Type.CONCRETE3,
		EmoteManager.Type.CONCRETE4,
		EmoteManager.Type.CONCRETE5,
		EmoteManager.Type.CONCRETE6,
		EmoteManager.Type.CONCRETE7,
	]
func construct_GROWTH():
	addJob(type + 1)
	stage = 1
	addCost(gv.Resource.STONE, 900)
	color = Color(0.79, 1, 0.05)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/growth.png")
	emotePool = [
		EmoteManager.Type.GROWTH0,
		EmoteManager.Type.GROWTH1,
		EmoteManager.Type.GROWTH2,
		EmoteManager.Type.GROWTH3,
		EmoteManager.Type.GROWTH4,
		EmoteManager.Type.GROWTH5,
		EmoteManager.Type.GROWTH6,
		EmoteManager.Type.GROWTH7,
		EmoteManager.Type.GROWTH8,
		EmoteManager.Type.GROWTH9,
	]
func construct_OIL():
	addJob(type + 1)
	stage = 1
	addCost(gv.Resource.COPPER, 1.6)
	addCost(gv.Resource.CONCRETE, 250)
	color = Color(0.65, 0.3, 0.66)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/oil.png")
	emotePool = [
		EmoteManager.Type.OIL0,
		EmoteManager.Type.OIL1,
		EmoteManager.Type.OIL2,
		EmoteManager.Type.OIL3,
		EmoteManager.Type.OIL4,
		EmoteManager.Type.OIL5,
		EmoteManager.Type.OIL6,
		EmoteManager.Type.OIL7,
		EmoteManager.Type.OIL8,
		EmoteManager.Type.OIL9,
		EmoteManager.Type.OIL10,
	]
func construct_TARBALLS():
	addJob(type + 1)
	stage = 1
	shorthandKey = "tar"
	addCost(gv.Resource.IRON, 350)
	addCost(gv.Resource.MALIGNANCY, 10)
	color = Color(0.56, 0.44, 1)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/tar.png")
	emotePool = [
		EmoteManager.Type.TARBALLS0,
		EmoteManager.Type.TARBALLS1,
		EmoteManager.Type.TARBALLS2,
		EmoteManager.Type.TARBALLS3,
		EmoteManager.Type.TARBALLS4,
		EmoteManager.Type.TARBALLS5,
		EmoteManager.Type.TARBALLS6,
		EmoteManager.Type.TARBALLS7,
		EmoteManager.Type.TARBALLS8,
	]
func construct_MALIGNANCY():
	addJob(type + 1)
	stage = 1
	shorthandKey = "malig"
	addCost(gv.Resource.IRON, 900)
	addCost(gv.Resource.COPPER, 900)
	addCost(gv.Resource.CONCRETE, 50)
	color = Color(0.88, 0.12, 0.35)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/malig.png")
	emotePool = [
		EmoteManager.Type.MALIGNANCY0,
		EmoteManager.Type.MALIGNANCY1,
		EmoteManager.Type.MALIGNANCY2,
		EmoteManager.Type.MALIGNANCY3,
		EmoteManager.Type.MALIGNANCY4,
		EmoteManager.Type.MALIGNANCY5,
		EmoteManager.Type.MALIGNANCY6,
		EmoteManager.Type.MALIGNANCY7,
		EmoteManager.Type.MALIGNANCY8,
		EmoteManager.Type.MALIGNANCY9,
		EmoteManager.Type.MALIGNANCY10,
		EmoteManager.Type.MALIGNANCY11,
		EmoteManager.Type.MALIGNANCY12,
		EmoteManager.Type.MALIGNANCY13,
	]
func construct_WATER():
	addJob(type + 1)
	stage = 2
	shorthandKey = "water"
	addCost(gv.Resource.STONE, 2500)
	addCost(gv.Resource.WOOD, 80)
	color = Color(0, 0.647059, 1)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/water.png")
	emotePool = [
		EmoteManager.Type.WATER0,
		EmoteManager.Type.WATER1,
		EmoteManager.Type.WATER2,
		EmoteManager.Type.WATER3,
		EmoteManager.Type.WATER4,
		EmoteManager.Type.WATER5,
		EmoteManager.Type.WATER6,
		EmoteManager.Type.WATER7,
		EmoteManager.Type.WATER8,
		EmoteManager.Type.WATER9,
	]
func construct_HUMUS():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.IRON, 600)
	addCost(gv.Resource.COPPER, 600)
	addCost(gv.Resource.GLASS, 30)
	color = Color(0.458824, 0.25098, 0)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/humus.png")
	emotePool = [
		EmoteManager.Type.HUMUS0,
		EmoteManager.Type.HUMUS1,
		EmoteManager.Type.HUMUS2,
		EmoteManager.Type.HUMUS3,
		EmoteManager.Type.HUMUS4,
		EmoteManager.Type.HUMUS5,
		EmoteManager.Type.HUMUS6,
		EmoteManager.Type.HUMUS7,
		EmoteManager.Type.HUMUS8,
	]
func construct_SOIL():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.CONCRETE, 1000)
	addCost(gv.Resource.HARDWOOD, 40)
	color = Color(0.737255, 0.447059, 0)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/soil.png")
	emotePool = [
		EmoteManager.Type.SOIL0,
		EmoteManager.Type.SOIL1,
		EmoteManager.Type.SOIL2,
		EmoteManager.Type.SOIL3,
		EmoteManager.Type.SOIL4,
		EmoteManager.Type.SOIL5,
		EmoteManager.Type.SOIL6,
		EmoteManager.Type.SOIL7,
	]
func construct_TREES():
	addJob(type + 1)
	stage = 2
	shorthandKey = "tree"
	addCost(gv.Resource.GROWTH, 150)
	addCost(gv.Resource.SOIL, 25)
	color = Color(0.772549, 1, 0.247059)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/tree.png")
	emotePool = [
		EmoteManager.Type.TREES0,
		EmoteManager.Type.TREES1,
		EmoteManager.Type.TREES2,
		EmoteManager.Type.TREES3,
		EmoteManager.Type.TREES4,
		EmoteManager.Type.TREES5,
		EmoteManager.Type.TREES6,
		EmoteManager.Type.TREES7,
		EmoteManager.Type.TREES8,
	]
func construct_SEEDS():
	addJob(type + 1)
	name = "Maybe"
	stage = 2
	shorthandKey = "seed"
	addCost(gv.Resource.COPPER, 800)
	addCost(gv.Resource.TREES, 2)
	color = Color(1, 0.878431, 0.431373)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/seed.png")
	emotePool = [
		EmoteManager.Type.SEEDS0,
		EmoteManager.Type.SEEDS1,
		EmoteManager.Type.SEEDS2,
		EmoteManager.Type.SEEDS3,
		EmoteManager.Type.SEEDS4,
		EmoteManager.Type.SEEDS5,
		EmoteManager.Type.SEEDS6,
		EmoteManager.Type.SEEDS7,
		EmoteManager.Type.SEEDS8,
	]
func construct_GALENA():
	addJob(type + 1)
	stage = 2
	shorthandKey = "gale"
	addCost(gv.Resource.STONE, 1100)
	addCost(gv.Resource.WIRE, 200)
	color = Color(0.701961, 0.792157, 0.929412)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/gale.png")
func construct_LEAD():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.STONE, 400)
	addCost(gv.Resource.GROWTH, 800)
	color = Color(0.53833, 0.714293, 0.984375)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/lead.png")
func construct_WOOD_PULP():
	addJob(type + 1)
	stage = 2
	shorthandKey = "pulp"
	addCost(gv.Resource.WIRE, 15)
	addCost(gv.Resource.GLASS, 30)
	color = Color(0.94902, 0.823529, 0.54902)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/pulp.png")
func construct_PAPER():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.CONCRETE, 1200)
	addCost(gv.Resource.STEEL, 15)
	color = Color(0.792157, 0.792157, 0.792157)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/paper.png")
func construct_TOBACCO():
	addJob(type + 1)
	stage = 2
	shorthandKey = "toba"
	addCost(gv.Resource.SOIL, 3)
	addCost(gv.Resource.HARDWOOD, 15)
	color = Color(0.639216, 0.454902, 0.235294)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/toba.png")
func construct_CIGARETTES():
	addJob(type + 1)
	stage = 2
	shorthandKey = "ciga"
	addCost(gv.Resource.HARDWOOD, 50)
	addCost(gv.Resource.WIRE, 120)
	color = Color(0.929412, 0.584314, 0.298039)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/ciga.png")
func construct_PETROLEUM():
	addJob(type + 1)
	stage = 2
	shorthandKey = "pet"
	addCost(gv.Resource.IRON, 3000)
	addCost(gv.Resource.COPPER, 4000)
	addCost(gv.Resource.GLASS, 130)
	color = Color(0.76, 0.53, 0.14)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/pet.png")
func construct_PLASTIC():
	addJob(type + 1)
	stage = 2
	shorthandKey = "plast"
	addCost(gv.Resource.STONE, 10000)
	addCost(gv.Resource.TARBALLS, 700)
	color = Color(0.85, 0.85, 0.85)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/plast.png")
func construct_CARCINOGENS():
	addJob(type + 1)
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
	addJob(type + 1)
	stage = 2
	shorthandKey = "liq"
	addCost(gv.Resource.CONCRETE, 30)
	addCost(gv.Resource.STEEL, 25)
	color = Color(0.27, 0.888, .9)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/liq.png")
func construct_STEEL():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.IRON, 15000)
	addCost(gv.Resource.COPPER, 3000)
	addCost(gv.Resource.HARDWOOD, 35)
	color = Color(0.607843, 0.802328, 0.878431)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/steel.png")
func construct_SAND():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.IRON, 700)
	addCost(gv.Resource.COPPER, 2850)
	color = Color(.87, .70, .45)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/sand.png")
	set_pronouns(Gender.FEMALE)
func construct_GLASS():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.COPPER, 6000)
	addCost(gv.Resource.STEEL, 40)
	color = Color(0.81, 0.93, 1.0)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/glass.png")
func construct_WIRE():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.STONE, 13000)
	addCost(gv.Resource.GLASS, 30)
	color = Color(0.9, 0.6, 0.14)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/wire.png")
	set_pronouns(Gender.FEMALE)
func construct_DRAW_PLATE():
	addJob(type + 1)
	stage = 2
	shorthandKey = "draw"
	addCost(gv.Resource.IRON, 900)
	addCost(gv.Resource.CONCRETE, 300)
	addCost(gv.Resource.WIRE, 20)
	color = Color(0.333333, 0.639216, 0.811765)
	fuelResource = gv.Resource.COAL
	icon = preload("res://Sprites/resources/draw.png")
	emotePool = [
		EmoteManager.Type.DRAW_PLATE0,
		EmoteManager.Type.DRAW_PLATE1,
		EmoteManager.Type.DRAW_PLATE2,
		EmoteManager.Type.DRAW_PLATE3,
		EmoteManager.Type.DRAW_PLATE4,
		EmoteManager.Type.DRAW_PLATE5,
		EmoteManager.Type.DRAW_PLATE6,
		EmoteManager.Type.DRAW_PLATE7,
		EmoteManager.Type.DRAW_PLATE8,
		EmoteManager.Type.DRAW_PLATE9,
		EmoteManager.Type.DRAW_PLATE10,
	]
func construct_AXES():
	addJob(type + 1)
	stage = 2
	shorthandKey = "axe"
	addCost(gv.Resource.IRON, 1000)
	addCost(gv.Resource.HARDWOOD, 55)
	color = Color(0.691406, 0.646158, 0.586075)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/axe.png")
func construct_WOOD():
	addJob(type + 1)
	stage = 2
	addCost(gv.Resource.COPPER, 4500)
	addCost(gv.Resource.WIRE, 15)
	color = Color(0.545098, 0.372549, 0.015686)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/wood.png")
func construct_HARDWOOD():
	addJob(type + 1)
	stage = 2
	shorthandKey = "hard"
	addCost(gv.Resource.IRON, 3500)
	addCost(gv.Resource.CONCRETE, 350)
	addCost(gv.Resource.WIRE, 35)
	color = Color(0.92549, 0.690196, 0.184314)
	fuelResource = gv.Resource.JOULES
	icon = preload("res://Sprites/resources/hard.png")
	set_pronouns(Gender.FEMALE)
func construct_TUMORS():
	addJob(type + 1)
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
	queue(lv.Queue.FUEL_COST)
	queue(lv.Queue.FUEL_STORAGE)
	queue(lv.Queue.OUTPUT)
	queue(lv.Queue.INPUT)
	queue(lv.Queue.COST)
	queue(lv.Queue.CRIT)
	queue(lv.Queue.HASTE)

var queue: Array
func queue(that: int):
	if queue.has(that):
		return
	queue.append(that)




# - - - Handy

func editValue(attribute: int, typeOfEdit: int, item: int, amount, index = -1):
	
	var callFunc: String
	var folder: int
	
	match typeOfEdit:
		lv.Num.MULTIPLY:
			callFunc = "multiplyValue"
			folder = lv.Num.MULTIPLY
		lv.Num.DIVIDE:
			callFunc = "divideValue"
			folder = lv.Num.MULTIPLY
		lv.Num.ADD:
			callFunc = "addToValue"
			folder = lv.Num.ADD
		lv.Num.SUBTRACT:
			callFunc = "subtractFromValue"
			folder = lv.Num.ADD
	
	match attribute:
		lv.Attribute.OUTPUT:
			outputBits.call(callFunc, folder, item, amount)
			queue(lv.Queue.OUTPUT)
		lv.Attribute.FUEL_COST:
			fuelCostBits.call(callFunc, folder, item, amount)
			queue(lv.Queue.FUEL_COST)
		lv.Attribute.FUEL_STORAGE:
			fuelStorageBits.call(callFunc, folder, item, amount)
			queue(lv.Queue.FUEL_STORAGE)
		lv.Attribute.HASTE:
			hasteBits.call(callFunc, folder, item, amount)
			queue(lv.Queue.HASTE)
		lv.Attribute.INPUT:
			if index == -1:
				inputBits.call(callFunc, folder, item, amount)
			else:
				if index in jobs.values()[0].requiredResourcesBits.keys():
					jobs.values()[0].requiredResourcesBits[index].call(callFunc, folder, item, amount)
			queue(lv.Queue.INPUT)
		lv.Attribute.COST:
			costBits[index].call(callFunc, folder, item, amount)
			queue(lv.Queue.COST)
		lv.Attribute.CRIT:
			critBits.call(callFunc, folder, item, amount)
			queue(lv.Queue.CRIT)



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
	},
}, "output")

func sync_OUTPUT():
	outputBits.updateDynamic(dynamic_OUTPUT)
	output = outputBits.total
	syncJobs_producedResources()
	updateOfflineNet = true

func getOutputText() -> String:
	return outputBits.totalText

func updateOutput():
	var modifier: Big = Big.new(2).power(level - 1)
	outputBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, modifier)
	queue(lv.Queue.OUTPUT)
func setOutputValue(folder: int, item: int, amount):
	outputBits.setValue(folder, item, amount)
	queue(lv.Queue.OUTPUT)

var producedResources: Array
func setProducedResources():
	producedResources = []
	for j in jobs:
		var poop = jobs[j].producedResourcesBits.keys()
		for p in poop:
			producedResources.append(p)

func resetOutput():
	outputBits.reset()



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
}, "input")

func sync_INPUT():
	inputBits.updateDynamic(dynamic_INPUT)
	input = inputBits.total
	syncJobs_requiredResources()
	if not gv.inFirstTwoSecondsOfRun():
		updateMaxDrain()

func getInputText() -> String:
	return inputBits.totalText

func updateInput():
	var modifier: Big = Big.new(2).power(level - 1)
	inputBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, modifier)
	queue(lv.Queue.INPUT)


var usedResources: Array
var usedBy: Array
func setUsedResources():
	for job in jobs.values():
		var poop = job.requiredResourcesBits.keys()
		for p in poop:
			usedResources.append(p)

func resetInput():
	inputBits.reset()



# - - - Cost

var cost := {}
var costText: Dictionary setget , getCostText
var costBits := {}
var costBitsUpdated := false
var costModifier := 3.0
var baseCost := {}
func addCost(_key: int, base: float):
	baseCost[_key] = base
	costBits[_key] = Bits.new({
		lv.Num.BASE: base,
		lv.Num.MULTIPLY: {
			lv.Num.FROM_UPGRADES: Big.new(1),
			lv.Num.FROM_LEVELS: Big.new(1),
		},
	}, "cost")
func removeCost(resource: int):
	if not resource in cost.keys():
		return
	costBits.erase(resource)
	cost.erase(resource)
func sync_COST():
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
		
		gv.stats["ResourceStats"]["spent"][c].a(cost[c])
		gv.emit_signal("ResourceSpent", c)
func updateCost():
	for c in costBits:
		var modifier: Big = Big.new(costModifier).power(level)
		costBits[c].setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, modifier)
	sync_COST()

func syncCostModifier():
	costModifier = 3.0
	if gv.up["upgrade_name"].active():
		if stage == 1 and fuelResource == gv.Resource.COAL:
			costModifier = 2.75
	if gv.up["upgrade_description"].active():
		costModifier *= 0.9
	updateCost()

func resetCost():
	for r in costBits:
		costBits[r].reset()



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
}, "fuelCost")

func sync_FUEL_COST():
	fuelCost = fuelCostBits.total

func getFuelCostText() -> String:
	return fuelCostBits.totalText

func updateFuelCost():
	var modifier: Big = Big.new(2).power(level - 1)
	fuelCostBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, modifier)
	queue(lv.Queue.FUEL_COST)

func resetFuelCost():
	fuelCostBits.reset()



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
}, "fuelStorage")

func sync_FUEL_STORAGE():
	fuelStorage = fuelStorageBits.total
	jobs[lv.Job.REFUEL].requiredResourcesBits[fuelResource].setValue(lv.Num.MULTIPLY, lv.Num.BY_LORED_FUEL_STORAGE, fuelStorage)

func getFuelStorageText() -> String:
	return fuelStorageBits.totalText
func getCurrentFuelText() -> String:
	return currentFuel.toString()

var currentFuelPercent setget , getCurrentFuelPercent
func getCurrentFuelPercent() -> float:
	return currentFuel.percent(fuelStorage)

func updateFuelStorage():
	var modifier: Big = Big.new(2).power(level - 1)
	fuelStorageBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, modifier)
	queue(lv.Queue.FUEL_STORAGE)


var quarterTank: Big setget setQuarterTank
var quarterTankText: String setget , getQuarterTankText
var quarterTankUpdated := true
func setQuarterTank(val: Big):
	quarterTank = val
	quarterTankUpdated = true
func getQuarterTankText() -> String:
	if quarterTankUpdated:
		setQuarterTankText()
	return quarterTankText
func setQuarterTankText():
	quarterTankUpdated = false
	quarterTankText = quarterTank.toString()

func resetFuelStorage():
	fuelStorageBits.reset()



# - - - Crit

var crit: float
var critText: String setget , getCritText
var critBits := BitsFloat.new({
	lv.Num.BASE: 0.0,
	lv.Num.ADD: {
		lv.Num.FROM_UPGRADES: 0.0,
	},
}, "crit")

func sync_CRIT():
	crit = critBits.total
	#critBits.report()

func getCritText() -> String:
	return critBits.totalText + "%"

func increaseCrit(folder: int, item: int, amount):
	critBits.multiplyValue(folder, item, amount)
	queue(lv.Queue.CRIT)

func resetCrit():
	critBits.reset()



# - - - Haste

var haste: float
var baseHaste: float setget , getBaseHaste
var hasteText: String setget , getHasteText
var hasteBits := BitsFloat.new({
	lv.Num.BASE: 1.0,
	lv.Num.MULTIPLY: {
		lv.Num.FROM_UPGRADES: 1.0,
	},
}, "haste")

func sync_HASTE():
	hasteBits.updateDynamic(dynamic_HASTE)
	haste = hasteBits.total
	syncJobs_duration()
	updateTotalJobTime = true
	updateOfflineNet = true

func getHasteText() -> String:
	return hasteBits.totalText

func setHasteValue(folder: int, item: int, amount):
	hasteBits.setValue(folder, item, amount)
	queue(lv.Queue.HASTE)

func getBaseHaste() -> float:
	return hasteBits.base

func resetHaste():
	hasteBits.reset()



# - Dynamic Upgrades

var dynamic_OUTPUT: Dictionary
var dynamic_INPUT: Dictionary
var dynamic_HASTE: Dictionary

func applyDynamicUpgrade(_key: String, effectIndex: int, folder: String):
	folder = "dynamic_" + folder
	if _key in get(folder).keys():
		return
	get(folder)[_key] = effectIndex
func removeDynamicUpgrade(_key: String, folder: String):
	folder = "dynamic_" + folder
	if _key in get(folder).keys():
		get(folder).erase(_key)



# - - - Jobs

var jobs: Dictionary
var sorted_job_keys: Array

func addJob(jobType: int):
	jobs[jobType] = Job.new(jobType, type)
	if is_instance_valid(manager):
		manager.store_produced_and_required_resources()
func syncJobs_all():
	for job in jobs:
		jobs[job].syncAll()
func syncJobs_duration():
	jobs[lv.Job.REFUEL].syncDuration()
	for job in jobs:
		jobs[job].syncDuration()
func syncJobs_producedResources():
	for job in jobs:
		jobs[job].syncProducedResources()
func syncJobs_requiredResources():
	jobs[lv.Job.REFUEL].syncRequiredResources()
	for job in jobs:
		jobs[job].syncRequiredResources()

func getJobDuration(index: int) -> float:
	return jobs.values()[index].duration

func sort_jobs():
	sorted_job_keys = []
	sorted_job_keys = jobs.keys()
	sorted_job_keys.sort()



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
	currentFuel.a(Big.new(fuelStorageBits.total).d(2))

func levelUp(newLevel := level + 1):
	
	level = newLevel
	
	updateFuelCost()
	updateFuelStorage()
	updateCost()
	updateOutput()
	updateInput()

func firstPurchaseOfTheRun():
	
	purchased = true
	
	level += 1
	
	updateCost()
	
	if type != lv.Type.STONE:
		setFuelToMax()
	else:
		if gv.run1 > 1:
			setFuelToMax()
	
	manager.enterActive()
	
	if type in gv.list.lored["unlocked and inactive"]:
		gv.list.lored["unlocked and inactive"].erase(type)
	
	gv.list.lored["active"].append(type)
	
	jobs.values()[0].unlock()
	
	if gv.up["THE WITCH OF LOREDELITH"].active():
		if stage == 1:
			BuffManager.apply_buff(BuffManager.Type.WITCH, type, {"max_ticks": -1})
	
	if not gv.s2_upgrades_may_be_autobought:
		gv.check_for_the_s2_shit()
func setFuelToMax():
	currentFuel = Big.new(fuelStorage)



# - - - Production

var lastJob := -1

func jobStarted(job: Job):
	if job.type == lastJob:
		if not queue.has(lv.Queue.UPDATE_PRODUCTION):
			return
	else:
		if not lastJob in [-1, lv.Job.REFUEL]:
			updateGain_zero(jobs[lastJob])
			updateDrain_zero(jobs[lastJob])
	lastJob = job.type
	if job.type == lv.Job.REFUEL:
		return
	job.unlockResources()
	if queue.has(lv.Queue.UPDATE_PRODUCTION):
		queue.erase(lv.Queue.UPDATE_PRODUCTION)
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
func updateMaxDrain():
	if asleep:
		updateMaxDrain_zero()
		return
	
	for job in jobs.values():
		
		if not job.requiresResource:
			continue
		
		var baseDrainRate: Dictionary = job.drainRate
		for r in baseDrainRate:
			lv.updateMaxDrain(r, type, baseDrainRate[r])
func updateMaxDrain_zero():
	for job in jobs.values():
		for r in job.requiredResources:
			lv.updateMaxDrain(r, type, Big.new(0))


func finishedWorkingForNow():
	if lastJob in [-1, lv.Job.REFUEL]:
		return
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


var totalJobTime: float setget , getTotalJobTime
var updateTotalJobTime := true
func getTotalJobTime() -> float:
	if updateTotalJobTime:
		setTotalJobTime()
	return totalJobTime
func setTotalJobTime():
	updateTotalJobTime = false
	totalJobTime = 0.0
	for j in jobs:
		totalJobTime += jobs[j].duration


func updateOfflineNet(resource: int):
	for job in jobs.values():
		job.updateOfflineNet(resource)
	updateOfflineNet = true

var updateOfflineNet := true
var offlineNet := {} setget , getOfflineNet
func getOfflineNet() -> Dictionary:
	if updateOfflineNet:
		setOfflineNet()
	return offlineNet
func setOfflineNet():
	updateOfflineNet = false
	offlineNet = {}
	for job in jobs.values():
		offlineNet[job.type] = job.getOfflineNet()

func getOfflineEarnings(timeOffline: int):
	
	var offNet = getOfflineNet()
	
	if not purchased:
		return
	
	for job in offNet:
		
		for resource in offNet[job]:
			
			var _sign: int = int(offNet[job][resource][1])
			
			if _sign == 0:
				gv.logOfflineEarnings(resource, Big.new(0), 0)
				continue
			
			var amount: Big = Big.new(offNet[job][resource][0])
			
			amount.m(timeOffline)
			
			if _sign == 1:
				gv.addToResource(resource, amount)
			elif _sign == -1:
				gv.subtractFromResource(resource, amount)
			
			gv.logOfflineEarnings(resource, amount, _sign) 



# - - - Actions

func remove_original_fuel_cost_from_relevant_jobs() -> void:
	for job in jobs.values():
		job.remove_fuel_cost()

func change_fuel_resource(new_fuel_resource: int) -> void:
	fuelResource = new_fuel_resource

func reset():
	level = 0
	fuelCostBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, Big.new(1))
	fuelStorageBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, Big.new(1))
	outputBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, Big.new(1))
	inputBits.setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, Big.new(1))
	for c in cost:
		costBits[c].setValue(lv.Num.MULTIPLY, lv.Num.FROM_LEVELS, Big.new(1))
	purchased = false
#	unlocked = true if key in ["stone", "coal"] else false
#
#	halfway_reset_stuff()



# - - - Pronouns

enum Gender {
	MALE,
	FEMALE,
}

func set_pronouns(_gender: int):
	if _gender == Gender.MALE:
		pronoun = ["he", "him", "his"]
	else:
		pronoun = ["she", "her", "hers"]
