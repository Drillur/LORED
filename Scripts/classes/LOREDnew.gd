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

var speed: Float

var key: String
var name: String

var job: String
var job_list := []
var current_job:
var last_job: String
var job_text: String

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

var in_hand: Big

var output: Ob.Num
var fuel: Ob.Num
var fuel_cost: Ob.Num



func _init(_type: int):

	type = type

	match type:
		
		gv.Lored.JOULES:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Joules"
			key = "jo"
			speed = Float.new(3.3)
			output = Ob.Num.new()
		
		gv.Lored.IRON:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Iron"
			key = "iron"
			speed = Float.new(2)
			output = Ob.Num.new()
		
		gv.Lored.COPPER:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Copper"
			key = "cop"
			speed = Float.new(2)
			output = Ob.Num.new()
		
		gv.Lored.IRON_ORE:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Iron Ore"
			key = "irono"
			speed = Float.new(1.6)
			output = Ob.Num.new()
		
		gv.Lored.COPPER_ORE:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Copper Ore"
			key = "copo"
			speed = Float.new(1.6)
			output = Ob.Num.new()

		gv.Lored.COAL:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Coal"
			key = "coal"
			speed = Float.new(1.3)
			output = Ob.Num.new()
		
		gv.Lored.STONE:
			stage = 1
			fuel_resource = gv.Lored.COAL
			name = "Stone"
			key = "stone"
			speed = Float.new()
			output = Ob.Num.new()

	setupCost()
	setupFuel()
	setupInput()
	setStageKey()
	populateEmotePool()
	setupResourceKeyValue()
	#color = gv.color[type]
	borer = input.size() == 0
	burner = fuel_resource == gv.Lored.COAL
	key_lored = key in gv.DEFAULT_KEY_LOREDS
	unlocked = type in [gv.Lored.STONE, gv.Lored.COAL]

	sync()

func setupInput():
	match type:
		gv.Lored.IRON:
			input[gv.Lored.IRON_ORE] = Ob.Num.new()
		
		gv.Lored.COPPER:
			input[gv.Lored.COPPER_ORE] = Ob.Num.new()

func setupCost():
	match type:
		gv.Lored.JOULES:
			cost[g.Lored.CONCRETE] = Ob.Num.new(25)
		
		gv.Lored.IRON:
			cost[g.Lored.STONE] = Ob.Num.new(9)
			cost[g.Lored.COPPER] = Ob.Num.new(8)
		
		gv.Lored.COPPER:
			cost[g.Lored.STONE] = Ob.Num.new(9)
			cost[g.Lored.IRON] = Ob.Num.new(8)
		
		gv.Lored.IRON_ORE:
			cost[g.Lored.STONE] = Ob.Num.new(8)
		
		gv.Lored.COPPER_ORE:
			cost[g.Lored.STONE] = Ob.Num.new(8)
		
		gv.Lored.COAL:
			cost[g.Lored.STONE] = Ob.Num.new(5)
		
		gv.Lored.STONE:
			cost[g.Lored.IRON] = Ob.Num.new(25)
			cost[g.Lored.COPPER] = Ob.Num.new(15)

func setupFuel():
	
	# fuel cost
	fuel_cost = Ob.Num.new(0.09)
	if stage == 2:
		fuel_cost.b.m(10)
	if not borer:
		fuel_cost.b.m(1.25)

	# max fuel
	if stage in [1, 2]:
		fuel = Ob.Num.new(fuel_cost.b)
		fuel.b.m(speed.b).m(40)
	elif stage == 3:
		fuel = Ob.Num.new(100)

	# current fuel
	if type == gv.Lored.STONE:
		fuel.f = Big.new(fuel_cost.b).m(speed.b).m(1.02)
	else:
		fuel.f = fuel.t

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
			emote_pool.append(Emote.new("bread is good,\nbut toast is better!", Vector2(130, 45)))
			emote_pool.append(Emote.new("thanks for working so hard, Stone!", Vector2(130, 45), "stone", "i couldn't do it without you, buddy!", Vector2(140, 45)))
			emote_pool.append(Emote.new("Iron Ore's methods may be extreme, but we need him nonetheless!", Vector2(135, 73), "irono", "i can hear you, but i'm going to pretend like i can't", Vector2(105, 73)))
			#emote_pool.append(Emote.new("Growth must be so smart to make Growth out of Iron and Copper.", Vector2(160, 59), "growth", "you're too kind! actually, all you do i--AHHHH OH GAWD", Vector2(140, 59)))
			emote_pool.append(Emote.new("Hardwood, can i borrow your helmet?", Vector2(100, 59), "hard", "yes, but actually no", Vector2(80, 45), "hard"))
			emote_pool.append(Emote.new("i shouldn't have left that one in for so long", Vector2(150, 45)))
			emote_pool.append(Emote.new("at this point, i'm going to need more toasters", Vector2(150, 45)))
			emote_pool.append(Emote.new("my arm is getting tired", Vector2(90, 45)))
			emote_pool.append(Emote.new("i think i need a helmet", Vector2(70, 59)))
		
		gv.Lored.COPPER:
			emote_pool.append(Emote.new("delicious!", Vector2(80, 39)))
			emote_pool.append(Emote.new(":)", Vector2(39, 39)))
			emote_pool.append(Emote.new("anyone want sm' more?", Vector2(90, 45)))
			emote_pool.append(Emote.new("sit close, it's cold out there", Vector2(100, 45)))
			emote_pool.append(Emote.new("can i get some more firewood?", Vector2(110, 45), "wood", "i got you, bro!", Vector2(100, 39)))
			emote_pool.append(Emote.new("stay awhile and listen to the fire", Vector2(110, 45)))
			emote_pool.append(Emote.new("dark thoughts, bright fire.\nsit with me", Vector2(105, 59)))
			emote_pool.append(Emote.new("thank you, Copper Ore, i appreciate you!", Vector2(145, 45), "copo", "gee, thanks, pal!", Vector2(80, 45)))
		
		gv.Lored.COPPER_ORE:
			emote_pool.append(Emote.new("it's a working man i am!", Vector2(95, 45)))
			emote_pool.append(Emote.new("i've been down underground", Vector2(105, 45)))
			emote_pool.append(Emote.new("i swear to god if i ever see the sun,", Vector2(120, 45)))
			emote_pool.append(Emote.new("or for any length of time, i can hold it in my mind,", Vector2(125, 59)))
			emote_pool.append(Emote.new("i never again will go down underground!", Vector2(140, 45)))
			
			emote_pool.append(Emote.new("at the age of sixteen years, i quarreled with my peers", Vector2(180, 45)))
			emote_pool.append(Emote.new("i swear there will never be another one", Vector2(140, 45)))
			emote_pool.append(Emote.new("in the dark recess of the mine, where you age before your time", Vector2(140, 59)))
			emote_pool.append(Emote.new("and the coal dust lies heavy on your lungs", Vector2(105, 59)))
			
			emote_pool.append(Emote.new("it's a working man i am!", Vector2(95, 45)))
			emote_pool.append(Emote.new("i've been down underground", Vector2(105, 45)))
			emote_pool.append(Emote.new("i swear to god if i ever see the sun,", Vector2(120, 45)))
			emote_pool.append(Emote.new("or for any length of time, i can hold it in my mind,", Vector2(125, 59)))
			emote_pool.append(Emote.new("i never again will go down underground!", Vector2(140, 45)))
			
			emote_pool.append(Emote.new("at the age of sixty-four, if i live that long,", Vector2(100, 59)))
			emote_pool.append(Emote.new("i'll greet you at the door and gently lead you by the arm", Vector2(140, 59)))
			emote_pool.append(Emote.new("in the dark recess of the mine, i can take you back in time", Vector2(140, 59)))
			emote_pool.append(Emote.new("and tell you of the hardships that were there!", Vector2(175, 45)))
		
		gv.Lored.IRON_ORE:
			emote_pool.append(Emote.new("DIE", Vector2(39, 39)))
			emote_pool.append(Emote.new("KILL", Vector2(39, 39)))
			emote_pool.append(Emote.new("GAH!", Vector2(45, 39)))
			emote_pool.append(Emote.new("BAH!", Vector2(45, 39)))
			emote_pool.append(Emote.new("this is what you GET", Vector2(85, 45)))
			emote_pool.append(Emote.new("RAHHugH", Vector2(75, 39)))
			emote_pool.append(Emote.new("MMUHRRaahhHRcK", Vector2(77, 45)))
			emote_pool.append(Emote.new("please die!", Vector2(50, 45)))
			emote_pool.append(Emote.new("can someone pass me some more shells?", Vector2(150, 45), "stone", "no, you creep!", Vector2(60,45)))
		
		gv.Lored.STONE:
			emote_pool.append(Emote.new("this one has a sweet edge!", Vector2(95, 45)))
			emote_pool.append(Emote.new("was that a hacky sack?", Vector2(90, 45)))
			emote_pool.append(Emote.new("my bag is getting heavy :(", Vector2(70, 59)))
			emote_pool.append(Emote.new("my back smarts :(", Vector2(70, 45)))
			emote_pool.append(Emote.new("hey, i found one you might like!", Vector2(115, 45)))
			emote_pool.append(Emote.new("gotta go fast!", Vector2(60, 45)))
			emote_pool.append(Emote.new("i wonder how much this one is worth.", Vector2(140, 45)))
			emote_pool.append(Emote.new("i don't like it when Iron Ore shoots rocks.", Vector2(155, 45), "irono", "rather i shoot you?", Vector2(80, 45)))
			
		gv.Lored.COAL:
			emote_pool.append(Emote.new("dig, dig!", Vector2(45, 45)))
			emote_pool.append(Emote.new("glad to help!", Vector2(65, 45)))
			emote_pool.append(Emote.new("is this lump yours?\njust kidding!", Vector2(100, 59)))
			emote_pool.append(Emote.new("i hope my posture is good!", Vector2(80, 59)))
			emote_pool.append(Emote.new("i'm grateful for my shovel.", Vector2(105, 45)))
			emote_pool.append(Emote.new("if you didn't get enough, go ahead and take some more!", Vector2(145, 59), "jo", "don't mind if i do!", Vector2(80, 45)))
			emote_pool.append(Emote.new("i always liked playing support.", Vector2(120, 45)))
			emote_pool.append(Emote.new("why is this stuff purple?", Vector2(95, 45)))



func sync():

	syncDynamics()

	fuel.sync()
	fuel_cost.sync()
	output.sync()
	speed.sync()
	crit.sync()
	syncCost()
	syncInput()

	gv.r[key].resetToZero_ifNegative()

func syncDynamics() -> void:
	
	output.da = Big.new(0)
	output.dm = Big.new(1)
	
	for x in dynamics:
		
		if not gv.up[x].active():
			continue
		
		if x == "Limit Break":
			output.lbm = gv.up[x].effects[0].effect.t
		
		match key:
			
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


func unlock():
	unlocked = true
	manager.show()
	managed = true


func purchased():

	times_purchased += 1
	takeawayAndIncreasePrice()
	taq.increaseProgress(gv.Objective.LORED_UPGRADED, type)
	
	if times_purchased == 1:
		firstTimePurchase()
		return

	level += 1

	output.m.m(2)
	fuel_cost.m.m(2)
	fuel.m.m(2)

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
	var minimum_fuel = Big.new(speed.t).m(fc.t).m(2)
	if fuel.f.less(minimum_fuel):
		fuel.f.a(minimum_fuel)


func canAfford() -> bool:
	for c in cost:
		if gv.resource[c].less(cost[c].t):
			return false
	return true



func resetCost():
	for c in cost:
		cost[c].reset()
