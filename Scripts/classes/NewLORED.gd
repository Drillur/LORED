class_name LOREDnew
extends Reference



var manager: MarginContainer
var managed := false

var type: int
var stage: int
var stage_key: int # refers to gv.Tab. Example: gv.Tab.S3
var fuel_resource: int
var level := 1
var times_purchased := 0

var name: String

var job: String
var job_list := []
var current_job: String
var last_job: String
var job_text: String

var emote_pool := []

var borer: bool
var burner: bool
var halt := false
var hold := false
var active := false
var autobuy := false
var working := false
var unlocked := false
var key_lored := false

var color: Color

var cost: Dictionary
var input: Dictionary

var dynamics := []

var in_hand: Big


var output := {
	gv.NumType.BASE: Big.new(1),
	gv.NumType.ADD: {
		gv.NumType.FROM_UPGRADES: 1,
	},
	gv.NumType.MULTIPLY: {
		gv.NumType.FROM_LEVELS: Big.new(1),
		gv.NumType.FROM_UPGRADES: Big.new(1),
		gv.NumType.LIMIT_BREAK: Big.new(1),
	},
} setget , getOutput

var curFuel: Big
var maxFuel: Big
var baseMaxFuel: Big
var addMaxFuel := Big.new(0)
var multMaxFuel := Big.new(1)

var fuelCost: Big
var baseFuelCost: Big
var addFuelCost := Big.new(0)
var multFuelCost := Big.new(1)

var speed: float
var baseSpeed: float

var critChance: float
var baseCritChance: float



func _init(_type: int):
	
	type = _type
	
	call("construct_" + gv.Lored.keys()[type])
	
	setName()
	setupCost()
	setupFuel()
	setupInput()
	setStageKey()
	populateEmotePool()
	setupResourceKeyValue()
	#color = gv.color[type]
	borer = input.size() == 0
	burner = fuel_resource == gv.Lored.COAL
	key_lored = type in gv.DEFAULT_KEY_LOREDS
	unlocked = type in [gv.Lored.STONE, gv.Lored.COAL]
	
	sync()

func setName():
	name = gv.Lored.keys()[type].replace("_", " ").capitalize()

func setupInput():
	match type:
		gv.Lored.IRON:
			input[gv.Lored.IRON_ORE] = Ob.Num.new()
		
		gv.Lored.COPPER:
			input[gv.Lored.COPPER_ORE] = Ob.Num.new()

func setupCost():
	match type:
		gv.Lored.JOULES:
			cost[gv.Lored.CONCRETE] = Ob.Num.new(25)
		
		gv.Lored.IRON:
			cost[gv.Lored.STONE] = Ob.Num.new(9)
			cost[gv.Lored.COPPER] = Ob.Num.new(8)
		
		gv.Lored.COPPER:
			cost[gv.Lored.STONE] = Ob.Num.new(9)
			cost[gv.Lored.IRON] = Ob.Num.new(8)
		
		gv.Lored.IRON_ORE:
			cost[gv.Lored.STONE] = Ob.Num.new(8)
		
		gv.Lored.COPPER_ORE:
			cost[gv.Lored.STONE] = Ob.Num.new(8)
		
		gv.Lored.COAL:
			cost[gv.Lored.STONE] = Ob.Num.new(5)
		
		gv.Lored.STONE:
			cost[gv.Lored.IRON] = Ob.Num.new(25)
			cost[gv.Lored.COPPER] = Ob.Num.new(15)

func setupFuel():
	
	# fuel cost
	baseFuelCost = Big.new(0.09)
	if stage == 2:
		baseFuelCost.m(10)
	if not borer:
		baseFuelCost.m(1.25)
	
	syncFuelCost()
	
	# max fuel
	if stage in [1, 2]:
		baseMaxFuel = Big.new(baseFuelCost).m(baseSpeed).m(40)
	elif stage == 3:
		baseMaxFuel = Big.new(100)
	
	syncMaxFuel()
	
	# current fuel
	if type == gv.Lored.STONE:
		curFuel = Big.new(baseFuelCost).m(baseSpeed).m(1.02)
	else:
		curFuel = Big.new(maxFuel)

func setupResourceKeyValue():
	if stage in [1, 2]:
		gv.resource[type] = Big.new(0)

func setStageKey():
	match stage:
		1: stage_key = gv.Tab.S1
		2: stage_key = gv.Tab.S2
		3: stage_key = gv.Tab.S3
		4: stage_key = gv.Tab.S4
		

func populateEmotePool():
	match type:
		gv.Lored.IRON:
			emote_pool.append(Emote.new("bread is good,\nbut toast is better!"))
			emote_pool.append(Emote.new("thanks for working so hard, Stone!", "stone", "i couldn't do it without you, buddy!"))
			emote_pool.append(Emote.new("Iron Ore's methods may be extreme, but we need him nonetheless!", "irono", "i can hear you, but i'm going to pretend like i can't"))
			#emote_pool.append(Emote.new("Growth must be so smart to make Growth out of Iron and Copper.", Vector2(160, 59), "growth", "you're too kind! actually, all you do i--AHHHH OH GAWD", Vector2(140, 59)))
			emote_pool.append(Emote.new("Hardwood, can i borrow your helmet?", "hard", "yes, but actually no"))
			emote_pool.append(Emote.new("i shouldn't have left that one in for so long"))
			emote_pool.append(Emote.new("at this point, i'm going to need more toasters"))
			emote_pool.append(Emote.new("my arm is getting tired"))
			emote_pool.append(Emote.new("i think i need a helmet"))
		
		gv.Lored.COPPER:
			emote_pool.append(Emote.new("this stuff's the knees! bees!"))
			emote_pool.append(Emote.new(":)"))
			emote_pool.append(Emote.new("anyone want sm' more?"))
			emote_pool.append(Emote.new("c'mon 'n rest ya dogs--try one of these bad bad boys"))
			emote_pool.append(Emote.new("can i get some more firewood?", "wood", "i got you, bro!"))
			emote_pool.append(Emote.new("stay awhile and listen to the fire"))
			emote_pool.append(Emote.new("mmmf!"))
			emote_pool.append(Emote.new("Copper Ore, these puppies are amazing!", "copo", "gee, thanks, pal!"))
		
		gv.Lored.COPPER_ORE:
			
			emote_pool.append(Emote.new("it's a working man i am!"))
			emote_pool.append(Emote.new("i've been down underground"))
			emote_pool.append(Emote.new("i swear to god if i ever see the sun,"))
			emote_pool.append(Emote.new("or for any length of time, i can hold it in my mind,"))
			emote_pool.append(Emote.new("i never again will go down underground!"))
			
			emote_pool.append(Emote.new("at the age of sixteen years, i quarreled with my peers"))
			emote_pool.append(Emote.new("i swear there will never be another one"))
			emote_pool.append(Emote.new("in the dark recess of the mine, where you age before your time"))
			emote_pool.append(Emote.new("and the coal dust lies heavy on your lungs"))
			
			emote_pool.append(Emote.new("it's a working man i am!"))
			emote_pool.append(Emote.new("i've been down underground"))
			emote_pool.append(Emote.new("i swear to god if i ever see the sun,"))
			emote_pool.append(Emote.new("or for any length of time, i can hold it in my mind,"))
			emote_pool.append(Emote.new("i never again will go down underground!"))
			
			emote_pool.append(Emote.new("at the age of sixty-four, if i live that long,"))
			emote_pool.append(Emote.new("i'll greet you at the door and gently lead you by the arm"))
			emote_pool.append(Emote.new("in the dark recess of the mine, i can take you back in time"))
			emote_pool.append(Emote.new("and tell you of the hardships that were there!"))
		
		gv.Lored.IRON_ORE:
			
			emote_pool.append(Emote.new("DIE"))
			emote_pool.append(Emote.new("KILL"))
			emote_pool.append(Emote.new("GAH!"))
			emote_pool.append(Emote.new("BAH!"))
			emote_pool.append(Emote.new("this is what you GET"))
			emote_pool.append(Emote.new("RAHHugH"))
			emote_pool.append(Emote.new("MMUHRRaahhHRcK"))
			emote_pool.append(Emote.new("please die!"))
			emote_pool.append(Emote.new("can someone pass me some more shells?", "stone", "no, you creep!"))
		
		gv.Lored.STONE:
			
			emote_pool.append(Emote.new("this one has a sweet edge!"))
			emote_pool.append(Emote.new("was that a hacky sack?"))
			emote_pool.append(Emote.new("my bag is getting heavy :("))
			emote_pool.append(Emote.new("my back smarts :("))
			emote_pool.append(Emote.new("hey, i found one you might like!"))
			emote_pool.append(Emote.new("gotta go fast!"))
			emote_pool.append(Emote.new("i wonder how much this one is worth."))
			emote_pool.append(Emote.new("i don't like it when Iron Ore shoots rocks.", "irono", "rather i shoot you?", "irono"))
			
		gv.Lored.COAL:
			
			emote_pool.append(Emote.new("dig, dig!"))
			emote_pool.append(Emote.new("glad to help!"))
			emote_pool.append(Emote.new("is this lump yours?\njust kidding!"))
			emote_pool.append(Emote.new("i hope my posture is good!"))
			emote_pool.append(Emote.new("i'm grateful for my shovel."))
			emote_pool.append(Emote.new("if you didn't get enough, go ahead and take some more!", "jo", "don't mind if i do!"))
			emote_pool.append(Emote.new("i always liked playing support."))
			emote_pool.append(Emote.new("why is this stuff purple?"))


func construct_JOULES():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 3.3
func construct_COPPER():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 2
func construct_IRON():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 2
func construct_IRON_ORE():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 1.6
func construct_COPPER_ORE():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 1.6
func construct_COAL():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 1.3
	output[gv.NumType.ADD][gv.NumType.I_DRINK_YOUR_MILKSHAKE] = Big.new(0)
func construct_STONE():
	stage = 1
	fuel_resource = gv.Lored.COAL
	speed = 1


func getOutput():
	return output[gv.NumType.TOTAL]

func increaseOutputAddFromUpgrades(val):
	output[gv.NumType.ADD][gv.NumType.FROM_UPGRADES].a(val)

func increaseOutputMultiplyFromLevels(val):
	output[gv.NumType.MULTIPLY][gv.NumType.FROM_UPGRADES].m(val)
func increaseOutputMultiplyFromUpgrades(val):
	output[gv.NumType.MULTIPLY][gv.NumType.FROM_LEVELS].m(val)
	
func setOutputMultiplyLimitBreak(val):
	output[gv.NumType.MULTIPLY][gv.NumType.LIMIT_BREAK] = Big.new(val)


func sync():
	
	syncDynamics()
	
	syncOutput()
	
	syncMaxFuel()
	syncFuelCost()
	syncOutput()
	syncSpeed()
	syncCritChance()
	syncCost()
	syncInput()
	
	gv.r[type].resetToZero_ifNegative()



func syncDynamics() -> void:
	
	setOutputMultiplyLimitBreak(gv.up["Limit Break"].effects[0].effect.t)
	
	for x in dynamics:
		
		if isNotActive():
			continue
		
		match type:
			
			gv.Lored.COAL:
				
				match x:
					"I DRINK YOUR MILKSHAKE":
						gv.up[x].sync_effects()
						output.da.a(gv.up[x].effects[0].effect.t)
			
			gv.Lored.IRON:
				
				match x:
					"IT'S GROWIN ON ME":
						gv.up[x].sync_effects()
						output.dm.m(gv.up[x].effects[0].effect.t)
			
			gv.Lored.COPPER:
				
				match x:
					"IT'S GROWIN ON ME":
						gv.up[x].sync_effects()
						output.dm.m(gv.up[x].effects[1].effect.t)
			
			gv.Lored.IRON_ORE:
				
				match x:
					"IT'S SPREADIN ON ME":
						gv.up[x].sync_effects()
						output.dm.m(gv.up[x].effects[0].effect.t)
			
			gv.Lored.COPPER_ORE:
				
				match x:
					"IT'S SPREADIN ON ME":
						gv.up[x].sync_effects()
						output.dm.m(gv.up[x].effects[1].effect.t)

func syncCost():
	for c in cost:
		cost[c].sync()

func syncInput():
	for i in input:
		input[i].sync()

func syncOutput():
	
	output[gv.NumType.TOTAL] = Big.new(output[gv.NumType.BASE])
	
	for f in output[gv.NumType.ADD]:
		output[gv.NumType.TOTAL].a(output[gv.NumType.ADD][f])
	
	for f in output[gv.NumType.MULTIPLY]:
		output[gv.NumType.TOTAL].a(output[gv.NumType.MULTIPLY][f])

func unlock():
	unlocked = true
	manager.show()
	managed = true


func purchased():
	
	times_purchased += 1
	takeawayAndIncreasePrice()
	#taq.increaseProgress(gv.Objective.LORED_UPGRADED, type) #note fix this
	
	if times_purchased == 1:
		firstTimePurchase()
		return
	
	level += 1
	
	increaseOutputMultiplyFromLevels(2)
	multFuelCost.m(2)
	multMaxFuel.m(2)
	
	sync()
	
	ensureAboveMinimumFuel()

func takeawayAndIncreasePrice():
	
	for c in cost:
		gv.resource[c].s(cost[c].t)

	var mod := 3.0

	if gv.up["upgrade_name"].active():
		if stage == 1 and fuel_resource == gv.Lored.COAL:
			mod = 2.75
	if gv.up["upgrade_description"].active():
		mod *= 0.9

	for c in cost:
		cost[c].m.m(mod)

	syncCost()

func firstTimePurchase():
	gv.list.lored["active " + str(stage_key)].append(type)
	active = true

func ensureAboveMinimumFuel():
	var minimum_fuel = Big.new(speed).m(fuelCost).m(2)
	if curFuel.less(minimum_fuel):
		curFuel.a(minimum_fuel)


func canAfford() -> bool:
	for c in cost:
		if gv.resource[c].less(cost[c].t):
			return false
	return true



func resetCost():
	for c in cost:
		cost[c].reset()


func syncFuelCost():
	
	fuelCost = baseFuelCost
	
	fuelCost.a(addFuelCost)
	
	fuelCost.m(multFuelCost)

func syncMaxFuel():
	
	maxFuel = baseMaxFuel
	
	maxFuel.a(addMaxFuel)
	
	maxFuel.m(multMaxFuel)

func syncSpeed():
	
	speed = baseSpeed

func syncCritChance():
	
	critChance = baseCritChance





func isActive() -> bool:
	# return false if the lored is either halted or inactive
	if not active:
		return false
	if halt:
		return false
	return true

func isNotActive() -> bool:
	return not isActive()
