class_name LORED
extends "res://Scripts/classes/Purchasable.gd"



var manager: MarginContainer
var current_job: Job

const saved_vars := ["active", "key_lored", "halt", "hold", "times_purchased", "level", "f"]

var unlocked := false
var active := false
var key_lored := false
var borer := true
var smart := false
var working := false
var halt := false
var hold := false 
var sync_queued := true
var off_sim := false


var b := {} # burn (ingredients burned per task)
var buff_keys := {}

var buffs := [] # buffs that have been applied directly to THIS Lored
var used_by := []
var task_list := []
var emote_pool := []
var jobs := []
var dynamics := []

var inhand := Big.new(0)
var witch := Big.new(0)

var spell_target := ""
var task := "no"
var task_text := ""
var last_task : String
var fuel_source: String

var color: Color

var level := 1
var d : Num # output; damage, basically
var f := Num.new() # fuel
var fc := Num.new() # fuel cost
var crit := Num.new(0.0) # crit chance
var speed: Float
var times_purchased := 0
var stage_key: int



func _init(
	_key: String,
	_name: String,
	_type: String,
	_burn: Dictionary,
	_cost: Dictionary,
	_speed: float,
	_base_d := 1.0) -> void:
	
	key = _key
	name = _name
	type = _type
	stage = type[1]
	smart = stage == "3"
	borer = "fur " in type and not stage in ["3"]
	key_lored = key in gv.DEFAULT_KEY_LOREDS
	color = gv.COLORS[key]
	
	setStageKey()
	setFuelSource()
	
	b = _burn
	cost = _cost
	initSpeed(_speed)
	initD(_base_d)
	
	active = key == "stone"
	unlocked = key in ["stone", "coal"]
	
	setStartingFuelDrain()
	setStartingBaseFuel()
	setStartingCurrentFuel()

	populate_emote_pool()

func initSpeed(_speed: float) -> void:
	speed = Float.new(_speed)
	speed.haxm = gv.hax_pow

func initD(_base_d: float) -> void:
	d = Num.new(_base_d)
	d.haxm = gv.hax_pow

func setStageKey() -> void:
	match stage:
		"1":
			stage_key = gv.Tab.S1
		"2":
			stage_key = gv.Tab.S2
		"3":
			stage_key = gv.Tab.S3
		"4":
			stage_key = gv.Tab.S4

func setFuelSource() -> void:
	
	if "ele" in type:
		fuel_source = "jo"
	elif "bur" in type:
		fuel_source = "coal"
	elif "water" in type:
		fuel_source = "water"
	elif "blood" in type:
		fuel_source = "blood"
	elif "mana" in type:
		fuel_source = "mana"

func setStartingFuelDrain() -> void:
	fc.b = Big.new(0.09)
	if stage == "2":
		increaseStartingFuelDrain_forStage2LOREDs()
	if not borer:
		increaseStartingFuelDrain_forFurnaceLOREDs()

func increaseStartingFuelDrain_forStage2LOREDs() -> void:
	fc.b.m(10)

func increaseStartingFuelDrain_forFurnaceLOREDs() -> void:
	fc.b.m(1.25)

func setStartingBaseFuel() -> void:
	if smart:
		setStartingBaseFuel_forSmartLOREDs()
	else:
		setStartingBaseFuel_forStupidLOREDs()
	f.sync()

func setStartingBaseFuel_forStupidLOREDs() -> void:
	f.b = Big.new(fc.b).m(speed.b).m(40)

func setStartingBaseFuel_forSmartLOREDs() -> void:
	match key:
		"witch":
			fc.b = Big.new(0.02 / 4)
			f.b = Big.new(3)
		"blood":
			fc.b = Big.new(0.09)
			f.b = Big.new(100)

func setStartingCurrentFuel() -> void:
	if key == "stone":
		f.f = Big.new(fc.b).m(speed.b).m(1.02)
		return
	
	f.f = Big.new(f.t)

func populate_emote_pool() -> void:

	match key:
		"malig":
			emote_pool.append(Emote.new("Hiya. I just coalesced out of sticky, oily stuff and cancer juice. How's your day going?"))
			emote_pool.append(Emote.new("Hi. Oh, wow, there are a lot of me."))
			emote_pool.append(Emote.new("Whoa, hello! I'm Malignancy... Oh, so are all of you?"))
			emote_pool.append(Emote.new("OH GOd--oh, hello."))
			emote_pool.append(Emote.new("Oh, hi! Nice to meet y'all!"))
			emote_pool.append(Emote.new("Wow! So THAT's what being born is like!"))
			emote_pool.append(Emote.new("Literally 1 second ago I did not exist. Isn't that weird to think about?"))
			emote_pool.append(Emote.new("Oop--hi! I'm Malignancy. Nice to meet you."))
			emote_pool.append(Emote.new("Hello!"))
			emote_pool.append(Emote.new("Hi!"))
			emote_pool.append(Emote.new("Hey!"))
			emote_pool.append(Emote.new("What's up?"))
			emote_pool.append(Emote.new("Hi, guys!"))
			emote_pool.append(Emote.new("Hey, I guess."))
		"tar":
			emote_pool.append(Emote.new("I'm still working on the perfect mixture."))
			emote_pool.append(Emote.new("That was good, but I can do better."))
			emote_pool.append(Emote.new("I lost some important notes. I need to be more careful."))
			emote_pool.append(Emote.new("I'm glad I'm able to work right now. I'm easily distracted."))
			emote_pool.append(Emote.new("I only live so long. I need to get this right!"))
			emote_pool.append(Emote.new("Thank you for your un-ending donations, Growth.", "growth", "I'm not donating it! How are you getting it??"))
			emote_pool.append(Emote.new("I can't wait for the next chapter of One-Punch Man!"))
			emote_pool.append(Emote.new("I'd like to see you wiggle, wiggle, for sure."))
			emote_pool.append(Emote.new("This makes me want to dribble, dribble."))
			
		"oil":
			emote_pool.append(Emote.new("but i'm just a baby"))
			emote_pool.append(Emote.new("plbdffffffffshh"))
			emote_pool.append(Emote.new("pow pow pow pow"))
			emote_pool.append(Emote.new("AHHHHHHHHHHH"))
			emote_pool.append(Emote.new("*crying*"))
			emote_pool.append(Emote.new("*pooped a little*"))
			emote_pool.append(Emote.new("*laughing*"))
			emote_pool.append(Emote.new("Slurp!!!"))
			emote_pool.append(Emote.new("Blahshshsjhbloff!"))
			emote_pool.append(Emote.new("Dada?"))
			emote_pool.append(Emote.new("Mama?"))
			emote_pool.append(Emote.new("Succ succ"))
		"conc":
			emote_pool.append(Emote.new("Que?"))
			emote_pool.append(Emote.new("Thank you, Primo!"))
			emote_pool.append(Emote.new("Quítate, chingada!"))
			emote_pool.append(Emote.new("Mi casa es su casa, hombre!"))
			emote_pool.append(Emote.new("Que pasa, jefe?"))
			emote_pool.append(Emote.new("No hablo Ingles. Can you translate?"))
			emote_pool.append(Emote.new("What channel is the soccer game on?"))
			emote_pool.append(Emote.new("Buenas noches, mi amor!"))
		"jo":
			emote_pool.append(Emote.new("It took me 12 years to be able to redirect lightning!"))
			emote_pool.append(Emote.new("My batteries are shock-full!"))
			emote_pool.append(Emote.new("Anyone's car need a jump-start?"))
			emote_pool.append(Emote.new("I can offer you parts at a reduced price!"))
			emote_pool.append(Emote.new("Thanks for the parts again, Coal. Same time, same place?", "coal", "See you next week!"))
			emote_pool.append(Emote.new("Cars cars cars cars cars cars cars!!!!!!"))
			emote_pool.append(Emote.new("Anyone need an oil change?", "oil", "Blblblfsh!!"))
		"growth":
			emote_pool.append(Emote.new("I think Oil just made a boom-boom.", "oil", "Hahahahaha!!"))
			emote_pool.append(Emote.new("Oh, your grandma got cancer three times? Must be nice."))
			emote_pool.append(Emote.new("Does such a thing as a chemotherapy water bed exist?", "tar", "Nope."))
			emote_pool.append(Emote.new("Call 9-1-1."))
			emote_pool.append(Emote.new("Send help."))
			emote_pool.append(Emote.new("The amount of water I need daily would shock anyone.", "jo", "Someone say shock?"))
			emote_pool.append(Emote.new("I had to go bald, I couldn't take the constant re-grooming."))
			emote_pool.append(Emote.new("In a way, this is satisfying!"))
		
		"iron":
			emote_pool.append(Emote.new("bread is good,\nbut toast is better!"))
			emote_pool.append(Emote.new("thanks for working so hard, Stone!", "stone", "i couldn't do it without you, buddy!"))
			emote_pool.append(Emote.new("Iron Ore's methods may be extreme, but we need him nonetheless!", "irono", "i can hear you, but i'm going to pretend like i can't"))
			#emote_pool.append(Emote.new("Growth must be so smart to make Growth out of Iron and Copper.", Vector2(160, 59), "growth", "you're too kind! actually, all you do i--AHHHH OH GAWD", Vector2(140, 59)))
			emote_pool.append(Emote.new("Hardwood, can i borrow your helmet?", "hard", "yes, but actually no"))
			emote_pool.append(Emote.new("i shouldn't have left that one in for so long"))
			emote_pool.append(Emote.new("at this point, i'm going to need more toasters"))
			emote_pool.append(Emote.new("my arm is getting tired"))
			emote_pool.append(Emote.new("i think i need a helmet"))
		
		"cop":
			emote_pool.append(Emote.new("this stuff's the knees! bees!"))
			emote_pool.append(Emote.new(":)"))
			emote_pool.append(Emote.new("anyone want sm' more?"))
			emote_pool.append(Emote.new("c'mon 'n rest ya dogs--try one of these bad bad boys"))
			emote_pool.append(Emote.new("can i get some more firewood?", "wood", "i got you, bro!"))
			emote_pool.append(Emote.new("stay awhile and listen to the fire"))
			emote_pool.append(Emote.new("mmmf!"))
			emote_pool.append(Emote.new("Copper Ore, these puppies are amazing!", "copo", "gee, thanks, pal!"))
		
		"copo":
			
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
		
		"irono":
			
			emote_pool.append(Emote.new("DIE"))
			emote_pool.append(Emote.new("KILL"))
			emote_pool.append(Emote.new("GAH!"))
			emote_pool.append(Emote.new("BAH!"))
			emote_pool.append(Emote.new("this is what you GET"))
			emote_pool.append(Emote.new("RAHHugH"))
			emote_pool.append(Emote.new("MMUHRRaahhHRcK"))
			emote_pool.append(Emote.new("please die!"))
			emote_pool.append(Emote.new("can someone pass me some more shells?", "stone", "no, you creep!"))
			emote_pool.append(Emote.new("so i literally want everyone to die.", "jo", "How shocking!"))
		
		"stone":
			emote_pool.append(Emote.new("this one has a sweet edge!"))
			emote_pool.append(Emote.new("was that a hacky sack?"))
			emote_pool.append(Emote.new("my bag is getting heavy :("))
			emote_pool.append(Emote.new("my back smarts :("))
			emote_pool.append(Emote.new("hey, i found one you might like!"))
			emote_pool.append(Emote.new("gotta go fast!"))
			emote_pool.append(Emote.new("i wonder how much this one is worth."))
			emote_pool.append(Emote.new("i don't like it when Iron Ore shoots rocks.", "irono", "rather i shoot you?", "irono"))
			
		"coal":
			
			emote_pool.append(Emote.new("dig, dig!"))
			emote_pool.append(Emote.new("glad to help!"))
			emote_pool.append(Emote.new("is this lump yours?\njust kidding!"))
			emote_pool.append(Emote.new("i hope my posture is good!"))
			emote_pool.append(Emote.new("i'm grateful for my shovel."))
			emote_pool.append(Emote.new("if you didn't get enough, go ahead and take some more!", "jo", "don't mind if i do!"))
			emote_pool.append(Emote.new("i always liked playing support."))
			emote_pool.append(Emote.new("why is this stuff purple?"))


func queueSync():
	sync_queued = true

func sync():
	
	sync_queued = false
	
	sync_dynamics()
	
	f.sync()
	d.sync()
	fc.sync()
	speed.sync()
	crit.sync()
	sync_cost() # in cPurchasable.gd
	for x in b:
		b[x].sync()
	
	gv.r[key].resetToZero_ifNegative()
	
	sync_Difficulty()

func sync_Difficulty():
	d.t.m(diff.getOutput())
	for x in b:
		b[x].t.m(diff.getInput())
	speed.t *= diff.getHaste()
	crit.t.a(diff.getCrit())
	f.t.m(diff.getFuelStorage())
	fc.t.m(diff.getFuelConsumption())

func sync_dynamics() -> void:
	
	d.da = Big.new(0)
	d.dm = Big.new(1)
	
	for x in dynamics:
		
		if not gv.up[x].active():
			continue
		
		if x == "Limit Break":
			d.lbm = gv.up[x].effects[0].effect.t
		
		match key:
			
			"coal":
				
				match x:
					"I DRINK YOUR MILKSHAKE":
						gv.up[x].sync_effects()
						d.da.a(gv.up[x].effects[0].effect.t)
			
			"iron":
				
				match x:
					"IT'S GROWIN ON ME":
						gv.up[x].sync_effects()
						d.dm.m(gv.up[x].effects[0].effect.t)
			
			"cop":
				
				match x:
					"IT'S GROWIN ON ME":
						gv.up[x].sync_effects()
						d.dm.m(gv.up[x].effects[1].effect.t)
			
			"irono":
				
				match x:
					"IT'S SPREADIN ON ME":
						gv.up[x].sync_effects()
						d.dm.m(gv.up[x].effects[0].effect.t)
			
			"copo":
				
				match x:
					"IT'S SPREADIN ON ME":
						gv.up[x].sync_effects()
						d.dm.m(gv.up[x].effects[1].effect.t)


func net(get_raw_power := false, ignore_halt := false) -> Array:
	
	# returns [gain, drain]
	
	var gain: Big
	var drain = Big.new(0)
	
	if active:
		gain = Big.new(d.t).d(speed.t).m(Big.new(1).a(crit.t.percent(10))).d(jobs[0].base_duration)
	else:
		gain = Big.new(0)
	
	# upgrade-specific per_sec bonuses
	if true:
		
		for x in ["cop", "stone", "iron"]:
			if key != x:
				continue
			var g = "copo"
			var u = "THE THIRD"
			match x:
				"stone":
					g = "coal"
					u = "wait that's not fair"
				"iron":
					g = "irono"
					u = "I RUN"
			
			if not gv.up[u].active() or not gv.g[g].active:
				continue
			
			var gay: Big = Big.new(gv.g[g].d.t).d(gv.g[g].speed.t).d(gv.g[g].jobs[0].base_duration).m(Big.new(1).a(Big.new(gv.g[g].crit.t).d(10)))
			
			gain.a(gay)
			
			break
		
		if active:
			if gv.Buff.HEX in buff_keys.keys():
				for x in buffs:
					if x.key == gv.Buff.HEX:
						gain.a(x.get_net())
			gain.a(witch)
	
	if get_raw_power:
		return [gain, drain]
	
	# halt or hold shit
	if not ignore_halt:
		
		if halt:
			gain = Big.new(0)
		
		# all below: candy from babies
		while "bur " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["coal"].level <= 5:
					if f.f.less(Big.new(f.t).m(0.1)):
						gain = Big.new(0)
						break
			if f.f.less(Big.new(f.t).m(0.1)) and not gv.g["coal"].active:
				gain = Big.new(0)
				break
			break
		
		while "ele " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["jo"].level <= 5:
					if f.f.less(Big.new(f.t).m(0.1)):
						gain = Big.new(0)
						break
			if f.f.less(Big.new(f.t).m(0.1)) and not gv.g["jo"].active:
				gain = Big.new(0)
				break
			break
		
		for x in b:
			if gv.up["don't take candy from babies"].active():
				if gv.g[x].type[1] == "1" and int(type[1]) > 1 and gv.g[x].level <= 5:
					gain = Big.new(0)
					break
			if not gv.g[x].hold: continue
			gain = Big.new(0)
			break
	
	# fuel lored
	if key in ["coal", "jo"]:
		
		for x in gv.g:
			
			if not gv.g[x].active:
				continue
			
			var cont := false
			for _b in gv.g[x].b:
				if gv.g[_b].hold:
					cont = true
				if cont:
					break
			if cont:
				continue
			
			if (key == "coal" and "bur " in gv.g[x].type) or (key == "jo" and "ele " in gv.g[x].type):
				if is_baby(int(gv.g[x].type[1])):
					continue
				drain.a(fuel_lored_net_loss(gv.g[x]))
	
	# checks all loreds that use this resource
	for x in used_by:
		
		if not ignore_halt:
			
			if gv.g[x].halt:
				continue
			if hold:
				break
			
			var brake = false
			for v in gv.g[x].b:
				if not gv.g[v].hold:
					continue
				brake = true
				break
			
			if brake:
				break
		
		
		if not gv.g[x].active:
			continue
		if is_baby(int(gv.g[x].type[1])):
			continue
		
		var gay: Big = Big.new(gv.g[x].d.t).d(gv.g[x].speed.t).m(gv.g[x].b[key].t).d(gv.g[x].jobs[0].base_duration)
		
		drain.a(gay)
	
	if drain.exponent < -10:
		drain.mantissa = 0.0
		drain.exponent = 0
	
	return [gain, drain]


func unlock():
	
	if unlocked:
		return
	
	unlocked = true
	manager.show()
	if not active:
		gv.list.lored["unlocked and inactive"].append(key)
		return
	if key != "stone":
		gv.list.lored["active"].append(key)

func bought():
	
	times_purchased += 1
	
	# price
	if true:
		
		for c in cost:
			gv.r[c].s(cost[c].t)
		
		increase_cost()
	
	taq.increaseProgress(gv.Objective.LORED_UPGRADED, key)
	
	gv.list.lored["active " + str(stage_key)].append(key)
	
	# already owned; upgrading
	if active:
		
		level += 1
		
		d.m.m(2)
		if not key in ["witch"]:
			fc.m.m(2)
			f.m.m(2)
		
		sync()
		
		if key == "blood":
			f.f.a(Big.new(f.t).d(2))
		
		if not smart and f.f.less(Big.new(speed.t).m(fc.t).m(2)):
			f.f.a(Big.new(speed.t).m(fc.t).m(2))
		
		return
	
	# not owned
	if true:
		
		if key in gv.list.lored["unlocked and inactive"]:
			gv.list.lored["unlocked and inactive"].erase(key)
		
		active = true
		gv.list.lored["active"].append(key)
		
		if not gv.s2_upgrades_may_be_autobought:
			if key in gv.loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
				gv.check_for_the_s2_shit()

func unlockResource():
	
	if not stage in ["1", "2"]:
		return
	
	for x in b:
		if not gv.g[x].unlocked:
			return
	
	if key in gv.list["unlocked resources"]:
		return
	
	gv.list["unlocked resources"].append(key)

func increase_cost() -> void:
	
	var mod := 3.0
	
	if gv.up["upgrade_name"].active():
		if type[1] == "1" and fuel_source == "coal":
			mod = 2.75
	if gv.up["upgrade_description"].active():
		mod *= 0.9
	
	for c in cost:
		cost[c].m.m(mod)
	
	sync_cost()

func is_baby(gx_type: int = int(type[1])) -> bool:
	
	# compares self and gx.
	# if self is baby and gx is adult, returns true
	
	if int(type[1]) >= 2:
		return false
	
	if not gv.up["don't take candy from babies"].active():
		return false
	
	if level > 4:
		return false
	
	if gx_type == 1:
		# it is a baby at this point, but
		# babies are allowed to take from other babies >:D
		return false
	
	return true

func fuel_lored_net_loss(gx: LORED) -> Big:
	
	var less = Big.new(gx.fc.t).m(4)
	
	if gx.f.f.less(Big.new(gx.f.t).s(less)):
		if gx.halt:
			return Big.new(gx.fc.t)
		return Big.new(gx.fc.t).m(2)
	
	if gx.halt:
		return Big.new(0)
	
	return Big.new(gx.fc.t)


func active() -> bool:
	# return false if the lored is either halted or inactive
	if not active:
		return false
	if halt:
		return false
	return true

func witch() -> void:
	
	witch = Big.new(0)
	
	if halt or stage != "1" or not gv.up["THE WITCH OF LOREDELITH"].active():
		return
	
	witch = Big.new(d.t).m(0.01).m(speed.b / speed.t).m(60).d(jobs[0].base_duration)
	
	if gv.up["GRIMOIRE"].active():
		witch.m(log(gv.run1))


func w_get_losing() -> float:
	
	var per_sec := 0.0
	
	if key == "coal" or key == "jo":
		for x in gv.g:
			
			if not gv.g[x].active: continue
			
			if (key == "coal" and "bur " in gv.g[x].type) or (key == "jo" and "ele " in gv.g[x].type):
				
				var go_for_it := true
				while f.level < 5:
					if not gv.up["don't take candy from babies"].active(): break
					if int(gv.g[x].type[1]) >= 2: go_for_it = false
					break
				
				if go_for_it:
					if gv.g[x].f.f < gv.g[x].f.t - (gv.g[x].fc.t * 3):
						per_sec += gv.g[x].fc.t * 120
					else:
						if not gv.g[x].halt: per_sec += gv.g[x].fc.t
	
	for x in used_by:
		if f.hold: break
		if gv.g[x].halt: continue
		var brake = false
		for v in gv.g[x].b:
			if not gv.g[v].hold: continue
			brake = true
			break
		if brake: break
		if not gv.g[x].active: continue
		if type[1] == "1" and level <= 5 and int(gv.g[x].type[1]) >= 2 and gv.up["don't take candy from babies"].active():
			continue
		per_sec += gv.g[x].d.t / gv.g[x].speed.t * gv.g[x].b[key].t
	
	return per_sec

func autobuy() -> bool:
	
	if not autobuy or off_sim:
		return false
	
	if not active:
		return true
	
	if halt:
		return false
	
	if autobuy_upgrade_check():
		return true
	
	# if ingredient LORED per_sec < per_sec, don't buy
	for x in b:
		
		if gv.g[x].hold:
			return false
		
		var consm = Big.new(b[x].t).m(d.t).d(speed.t).d(jobs[0].base_duration)
		# how much this lored consumes from the ingredient lored (x)
		
		if gv.g[x].halt:
			
			var consm2 = Big.new(consm).m(2)
			if consm2.less(gv.g[x].net(true)[0]):
				if not gv.g[x].cost_check():
					return false
		
		else:
			
			var net = gv.g[x].net()
			
			if net[0].less(net[1]):
				return false
			
			net = Big.new(net[0]).s(net[1])
			if consm.greater(net):
				if not gv.g[x].cost_check():
					return false
	
	if key_lored:
		return true
	
	var net = net()
	if net[0].greater(net[1]):
		# if total gain per sec is greater than total loss per sec
		return false
	
	return true

func autobuy_upgrade_check() -> bool:
	
	if stage == "1" and gv.up["don't take candy from babies"].active() and level < 5:
		return true
	
	match key:
		"malig", "iron", "cop":
			if gv.up["THE WITCH OF LOREDELITH"].active():
				return true
		"irono":
			if gv.up["I RUN"].active():
				return true
		"copo":
			if gv.up["THE THIRD"].active():
				return true
		"coal":
			if gv.up["wait that's not fair"].active():
				return true
	
	return false

func off_go(div: float) -> void:
	
	# divide speed by div
	
	speed.off_m *= div
	speed.sync()
	
	off_sim = true

func off_stop(div: float) -> void:
	
	speed.off_m /= div
	speed.sync()
	
	off_sim = false

func reset():
	
	f.reset()
	d.reset()
	fc.reset()
	speed.reset()
	crit.reset()
	reset_cost()
	for x in b:
		b[x].reset()
	
	active = true if key == "stone" else false
	unlocked = true if key in ["stone", "coal"] else false
	
	if key == "stone":
		f.f = Big.new(fc.b).m(speed.b).m(1.02)
	
	halfway_reset_stuff()

func halfway_reset_stuff():
	
	# things that should be done during all kinds of resets
	
	level = 1
	task = "no"
	
	active = true if key == "stone" else false
	halt = false
	hold = false
	
	f.sync()
	if key != "stone":
		f.f = Big.new(f.t)
	
	witch()
	
	inhand = Big.new(0)
	
	manager.stop()
	
	sync()

func partial_reset():
	
	d.lbm = Big.new(gv.up["Limit Break"].effects[0].effect.t)
	d.m = Big.new()
	fc.m = Big.new()
	f.m = Big.new()
	
	for c in cost:
		cost[c].m = Big.new()
	sync_cost()
	
	halfway_reset_stuff()

func logic() -> String:
	
	if halt:
		return "idle"
	
	if smart:
		return call(key + "_logic")
	
	if f.f.less(Big.new(speed.t).m(fc.t).m(2)):
		return "na " + fuel_source
	
	if borer:
		return "bore " + key
	
	# all below has "fur " in type
	
	# catches -- return "na "
	if true:
		
		for x in b:
			if gv.g[x].hold:
				return "na burn"
			if gv.r[x].less(Big.new(d.t).m(b[x].t)):
				return "na burn"
			if x == "iron" and Big.new(gv.r["iron"]).a(d.t).less_equal(20):
				return "na burn"
			if x == "cop" and Big.new(gv.r["cop"]).a(d.t).less_equal(20):
				return "na burn"
			if x == "stone" and Big.new(gv.r["stone"]).a(d.t).less_equal(30):
				return "na burn"
			if gv.up["don't take candy from babies"].active():
				if "1" == gv.g[x].stage and not "1" == stage and gv.g[x].level < 5:
					return "na burn"
		
		# unique ifs
		if true:
			match key:
				"jo":
					if gv.r["coal"].less(gv.g["coal"].d.t):
						return "na burn"
	
	return "cook " + key

func can_work() -> bool:

	if not unlocked:
		return false
	
	if not gv.g[fuel_source].unlocked:
		return false
	
	for _b in b:
		if not gv.g[_b].unlocked:
			return false
	
	return true
func can(_task: String) -> bool:
	return _task in task_list

func update_goal(goal: String):
	
	manager.gn_item_name.text = goal



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
	
	if not active:
		return
	
	unlockResource()
	
	level = str2var(data["level"])
	
	if not gv.option["on_save_halt"]:
		halt = false
	if not gv.option["on_save_hold"]:
		hold = false
	
	gv.list.lored["active " + str(stage_key)].append(key)
	
	if key != "stone":
		increase_cost()
	
	for x in level - 1:
		d.m.m(2)
		fc.m.m(2)
		f.m.m(2)
		increase_cost()
	
	f.f = f.t
	
	sync()



