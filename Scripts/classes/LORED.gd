class_name LORED
extends "res://Scripts/classes/Purchasable.gd"



var manager: MarginContainer

var unlocked := false
var active := false
var key_lored := false
var borer := true
var smart := false

var upgrade_quest: Task

var buff_keys := {}
var buffs := [] # buffs that have been applied directly to THIS Lored

var used_by := []
var task_list := []

var progress := Float.new()
var task := "no"
var task_text := ""
var last_task : String
var inhand := Big.new(0)

var color: Color

var level := 1
var d : Num # output; damage, basically
var f := Num.new() # fuel
var fc := Num.new() # fuel cost
var b := {} # burn (ingredients burned per task)
var halt := false
var hold := false
var sync_queued := true
var speed: Float
var crit := Num.new(0.0) # crit chance

var spell_target := ""

var inventory: Dictionary

var witch := Big.new(0)

var fuel_source: String

var dynamics := []


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
	
	# inventory init
	match key:
		"necro":
			inventory = {}
			inventory["knife"] = 1.0
		"hunt":
			inventory = {}
			inventory["water flask"] = 0
			inventory["hemp"] = 0
			inventory["arrow"] = 50
			inventory["bowstring"] = 0
			inventory["knife"] = 1.0
			inventory["bow"] = 1.0
		"witch":
			inventory = {}
			inventory[gv.Item.PIECES] = Big.new(0)
			inventory[gv.Item.PARTS] = Big.new(0)
			inventory[gv.Item.PORTIONS] = Big.new(0)
			inventory[gv.Item.BITS] = Big.new(0)
			
			inventory[gv.Item.SLICES] = Big.new(0)
			inventory[gv.Item.SAMPLES] = Big.new(0)
			inventory[gv.Item.SHARDS] = Big.new(0)
			inventory[gv.Item.CRUMBS] = Big.new(0)
	
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
	
	if "fur " in type:
		borer = false
	
	if key in ["hunt", "necro", "blood", "witch"]:
		smart = true
	
	b = _burn
	cost = _cost
	speed = Float.new(_speed / 60)
	d = Num.new(_base_d)
	
	color = gv.COLORS[key]
	
	if key in gv.DEFAULT_KEY_LOREDS:
		key_lored = true
	
	if key == "stone":
		active = true
	
	if key in ["stone", "coal"]:
		unlocked = true
	
	# drain
	fc.b = Big.new(0.09)
	if "s2" in type:
		fc.b.m(10)
	if "fur " in type:
		fc.b.m(1.25)
	
	# fuel
	if smart:
		match key:
			"witch":
				fc.b = Big.new(0.02 / 4)
				f.b = Big.new(3)
			"hunt":
				fc.b = Big.new(0.15)
				f.b = Big.new(25)
			"blood":
				fc.b = Big.new(0.09)
				f.b = Big.new(100)
	else:
		f.b = Big.new(fc.b).m(2000)
		f.b.m(speed.b).m(0.0125)
	
	f.sync()
	if key == "stone":
		f.f = Big.new(fc.b).m(speed.b).m(1.02)
	else:
		f.f = Big.new(f.t)
	



func sync():
	
	# dynamic effects left to sync:
	# crit, milkshake,
	
	sync_queued = false
	
	sync_dynamics()
	
	f.sync()
	progress.sync()
	d.sync()
	fc.sync()
	speed.sync()
	crit.sync()
	sync_cost() # in cPurchasable.gd
	for x in b:
		b[x].sync()
	
	
	if gv.r[key].less(0):
		gv.r[key] = Big.new(0)
	if gv.r[key].mantissa < 0:
		gv.r[key].mantissa = 0.0
	
	if gv.hax_pow != 1:
		d.t.m(gv.hax_pow)
		speed.t /= gv.hax_pow

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
	
	var gain = Big.new(d.t).d(speed.t).m(Big.new(1).a(crit.t.percent(10)))
	var drain = Big.new(0)
	
	if not active:
		gain.m(0)
	
	# upgrade-specific per_sec bonuses
	if true:
		
		if key == "cop" and gv.up["THE THIRD"].active() and gv.g["copo"].active():
			var gay = Big.new(gv.g["copo"].d.t).d(gv.g["copo"].speed.t)
			gay.m(Big.new(1).a(Big.new(gv.g["copo"].crit.t).d(10)))
			gain.a(gay)
		
		if key == "stone" and gv.up["wait that's not fair"].active() and gv.g["stone"].active():
			var gay = Big.new(gv.g["coal"].d.t).d(gv.g["coal"].speed.t)
			gay.m(Big.new(1).a(Big.new(gv.g["coal"].crit.t).d(10)))
			gain.a(gay)
		
		if key == "iron" and gv.up["I RUN"].active() and not gv.g["iron"].active():
			var gay = Big.new(gv.g["irono"].d.t).d(gv.g["irono"].speed.t)
			gay.m(Big.new(1).a(Big.new(gv.g["irono"].crit.t).d(10)))
			gain.a(gay)
		
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
			gain.m(0)
		
		# all below: candy from babies
		while "bur " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["coal"].level <= 5:
					if f.f.less(Big.new(f.t).m(0.1)):
						gain.m(0)
						break
			if f.f.less(Big.new(f.t).m(0.1)) and not gv.g["coal"].active:
				gain.m(0)
				break
			break
		
		while "ele " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["jo"].level <= 5:
					if f.f.less(Big.new(f.t).m(0.1)):
						gain.m(0)
						break
			if f.f.less(Big.new(f.t).m(0.1)) and not gv.g["jo"].active:
				gain.m(0)
				break
			break
		
		for x in b:
			if gv.up["don't take candy from babies"].active():
				if gv.g[x].type[1] == "1" and int(type[1]) > 1 and gv.g[x].level <= 5:
					gain.m(0)
					break
			if not gv.g[x].hold: continue
			gain.m(0)
			break
	
	# fuel lored
	if key in ["coal", "jo"]:
		
		for x in gv.g:
			
			if not gv.g[x].active:
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
		
		var gay = Big.new(gv.g[x].d.t).d(gv.g[x].speed.t).m(gv.g[x].b[key].t)
		drain.a(gay)
	
	if drain.exponent < -10:
		drain.mantissa = 0.0
		drain.exponent = 0
	
	return [gain, drain]


func unlock():
	unlocked = true
	manager.show()

func bought():
	
	# price
	if true:
		
		for c in cost:
			gv.r[c].s(cost[c].t)
		
		increase_cost()
	
	# task stuff
	if taq.cur_quest != -1:
		
		taq.progress(gv.TaskRequirement.LORED_UPGRADED, key)
	
	# already owned; upgrading
	if active:
		
		level += 1
		
		d.m.m(2)
		if not key in ["hunt", "witch"]:
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
		
		active = true
		unlocked = true
		
		gv.stats.g_list["active s" + str(stage)].append(key)
		
		if not gv.s2_upgrades_may_be_autobought:
			if key in gv.loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
				gv.check_for_the_s2_shit()

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
	# return true if the lored is either halted or inactive
	if not active: return false
	if halt: return false
	return true

func witch() -> void:
	
	witch = Big.new(0)
	
	if halt or stage != "1" or not gv.up["THE WITCH OF LOREDELITH"].active():
		return
	if "no" in gv.menu.f:
		return
	
	witch = Big.new(d.t).m(0.01).m(speed.b / speed.t).m(60)
	
	if gv.up["GRIMOIRE"].active():
		witch.m(log(gv.stats.run[0]))


func w_get_losing() -> float:
	
	var per_sec := 0.0
	
	if key == "coal" or key == "jo":
		for x in gv.g:
			
			if not gv.g[x].active: continue
			
			if (key == "coal" and "bur " in gv.g[x].type) or (key == "jo" and "ele " in gv.g[x].type):
				
				var go_for_it := true
				while f.level <= 5:
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
	
	if not autobuy:
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
		
		var consm = Big.new(b[x].t).m(d.t.percent(speed.t))
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
	
	if "1" == type[1]:
		if gv.up["don't take candy from babies"].active() and level < 6:
			return true
	
	match key:
		"malig":
			if gv.up["THE WITCH OF LOREDELITH"].active():
				return true
		"iron", "cop":
			if gv.up["IT'S SPREADIN ON ME"].active():
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


func reset():
	
	f.reset()
	progress.reset()
	d.reset()
	fc.reset()
	speed.reset()
	crit.reset()
	reset_cost()
	for x in b:
		b[x].reset()
	
	unlocked = true if key in ["stone", "coal"] else false
	
	halfway_reset_stuff()

func halfway_reset_stuff():
	
	# things that should be done during all kinds of resets
	
	level = 1
	task = "no"
	
	active = true if key == "stone" else false
	halt = false
	hold = false
	
	f.sync()
	f.f = Big.new(f.t)
	
	witch()
	
	inhand = Big.new(0)
	progress.f = 0.0
	progress.b = 1.0
	
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
	
	if "no" in gv.menu.f:
		if int(stage) <= int(gv.menu.f.split(" s")[1]):
			return "idle"
	
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

func can(_task: String) -> bool:
	return _task in task_list

func update_goal(goal: String):
	
	manager.gn_item_name.text = goal

func hunt_logic() -> String:
	
	if f.f.percent(f.t) < 0.5:
		
		# fuel bar is < 50%
		
		if inventory["water flask"] >= 1:
			# has water in inventory, so drinking from it
			return "drink water from flask"
		
		if can("use water flasks"):
			if gv.r["water"].greater_equal(30):
				return "fill up water flasks"
		
		if gv.r["water"].greater_equal(20):
			return "drink water"
		
		return "scrounge water"
	
	if gv.g["blood"].active:
		
		# if the Blood LORED exists, let him use it
		pass
	
	else:
		
		# otherwise, debone it
		if gv.r["processed beast"].greater_equal(d.t):
			return "debone beast"
	
	if inventory["arrow"] < 10:
		
		if gv.r["wood"].less(50):
			return "na wood"
		if gv.r["stone"].less(50):
			return "na stone"
		
		# costs 50 wood, 50 stone
		# gains 50 arrow
		return "craft arrows"
	
	if inventory["bow"] <= 0.1:
		
		if inventory["bowstring"] <= 0:
			
			if inventory["hemp"] <= 0:
				# gains (1-3) hemp
				return "collect hemp"
			
			# costs 1 hemp
			# gains 1 bowstring
			return "craft bowstring"
		
		if gv.r["wood"].less(15):
			return "na wood"
		
		# costs 15 wood, 1 bowstring
		# gains 1 bow
		return "craft bow"
	
	if gv.r["bagged beast"].less(d.t):
		# costs (3-8) arrow, (0-0.1) bow
		# gains 1 bagged beast
		return "hunt beast"
	
	if inventory["knife"] <= 0.1:
		
		if gv.r["stone"].less(3):
			return "na stone"
		
		# costs 3 stone
		# gains 1 knife
		return "craft knife"
	
	#note: here is where u should be like "if u want the blood lored to exsanguinate the live beast, etc etc"
	# costs 1 bagged beast, (0-0.1) knife
	# gains (1-5) meat, (0-10) fur, 1 processed beast
	return "process beast"

func blood_logic() -> String:
	
	if can("sacrifice own blood"):
		if gv.g[key].f.f.percent(gv.g[key].f.t) >= 0.9:
			# costs d.t fuel (blood)
			# gv.r["blood"].a(gv.g[key].d.t)
			return "sacrifice own blood"
	
	if can("exsanguinate nearly dead"):
		if gv.r["nearly dead"].greater_equal(d.t):
			# costs d.t nearly dead
			# gains (d.t * (100-200)) blood
			return "exsanguinate nearly dead"
	
	if can("exsanguinate beast"):
		if gv.r["processed beast"].greater_equal(d.t):
			# costs d.t beast bodies
			# gains (d.t * (50-100)) blood
			return "exsanguinate beast"
	
	if can("process tumors"):
		if gv.r["tum"].greater_equal(Big.new(d.t).m(100)):
			# costs 100 Tumors
			# gains 20 blood
			return "process tumors"
	
	if gv.r["growth"].greater_equal(Big.new(d.t).m(1000)):
		# costs 1000 Growth
		# gains 5 blood
		return "process growth"
	
	return "na growth"

func necro_logic() -> String:
	
	if gv.unholy_bodies.size() < 20:
		if can("resurrect flayed corpse"):
			if gv.r["unholy body"].less_equal(d.t) or gv.unholy_bodies[gv.latest_unholy_body].life < 15 * speed.t or gv.r["flesh"].greater(Big.new(d.t).m(100)):
				if gv.r["flayed corpse"].greater_equal(d.t):
					# costs d.t flayed corpse
					# gains d.t unholy body
					return "resurrect flayed corpse"
		else:
			if gv.r["unholy body"].equal(0):
				if gv.r["corpse"].greater_equal(d.t):
					# costs d.t flayed corpse
					# gains d.t unholy body
					return "resurrect corpse"
	
	if can("debone defiled dead"):
		if gv.r["defiled dead"].greater_equal(d.t):
			# costs d.t ^
			# gains (10-15)d.t bones
			return "debone defiled dead"
	
	if can("debone exsanguinated beast"):
		if gv.r["exsanguinated beast"].greater_equal(d.t):
			# costs 1 ^
			# gains (3-5)d.t bones
			return "debone exsanguinated beast"
	
	if can("flay corpse"):
		if gv.r["corpse"].greater_equal(d.t):
			
			if inventory["knife"] <= 0.1:
				
				if gv.r["stone"].less(3):
					return "na stone"
				
				# costs 3 stone
				# gains 1 knife
				return "craft knife"
			
			# costs d.t corpse, (0-0.1) knife
			# gains 2d.t flesh, 1d.t flayed corpse
			return "flay corpse"
	
	# a batch of unholy bodies (based on d.t) lives for 1 minute and consumes (3-5)d.t flesh
	
	if gv.unholy_bodies.size() < 20:
		if can("resurrect flayed corpse"):
			if gv.r["flayed corpse"].greater_equal(d.t):
				# costs d.t flayed corpse
				# gains d.t unholy body
				return "resurrect flayed corpse"
		else:
			if gv.r["corpse"].greater_equal(d.t):
				# costs d.t flayed corpse
				# gains d.t unholy body
				return "resurrect corpse"
	
	return "idle"

func witch_logic() -> String:
	
	if can("cast hex"):
		return witch_try_casting(gv.spells[gv.SpellID.HEX])
	
	if can("meditate"):
		if gv.g[key].f.f.less(Big.new(gv.g[key].f.t).m(0.9)):
			update_goal("Wants more mana :)")
			return "meditate"
	
	update_goal("Grinding")
	
	return witch_grind()

func witch_grind() -> String:
	
	for x in inventory:
		if x in [gv.Item.BITS, gv.Item.CRUMBS]:
			continue
		if inventory[x].less(Big.new(d.t).m(3)):
			return witch_get(x)
	
	if randi() % 2 == 0:
		return witch_get(gv.Item.CRUMBS)
	return witch_get(gv.Item.BITS)

func witch_try_casting(spell: Spell) -> String:
	
	for x in spell.cost:
		
		# first, obtain all of the required costs before casting the spell
		
		if x == gv.Item.MANA:
			if gv.g[key].f.f.greater(spell.cost[x].t):
				continue
			if can("meditate"):
				update_goal("Wants to cast " + spell.name + "; getting more mana :)")
				return "meditate"
			update_goal("Wants to cast " + spell.name + "; has insufficient mana :(")
			return witch_grind()
		
		if inventory[x].less(spell.cost[x].t):
			update_goal("Wants to cast " + spell.name + "; needs " + Big.new(spell.cost[x].t).s(inventory[x]).toString() + " more " + gv.item_names[x])
			return witch_get(x)
	
	match spell.key:
		gv.SpellID.HEX:
			while true:
				spell_target = gv.stats.g_list["s1"][randi() % gv.stats.g_list["s1"].size()]
				if gv.g[spell_target].active:
					break
	
	update_goal("It's " + spell.name + " time, now :)")
	
	return "cast " + str(spell.key)

func witch_get(item: int) -> String:
	
	if item in [gv.Item.CRUMBS, gv.Item.BITS]:
		return "find " + str(item)
	
	# will scavenge for or craft item
	
	var cost = Big.new(d.t)
	var ingredient: String
	
	match item:
		gv.Item.PIECES:
			cost.m(8)
			ingredient = str(gv.Item.BITS)
		gv.Item.PARTS:
			cost.m(10)
			ingredient = str(gv.Item.BITS)
		gv.Item.PORTIONS:
			cost.m(12)
			ingredient = str(gv.Item.BITS)
		
		gv.Item.SLICES:
			cost.m(10)
			ingredient = str(gv.Item.CRUMBS)
		gv.Item.SAMPLES:
			cost.m(12)
			ingredient = str(gv.Item.CRUMBS)
		gv.Item.SHARDS:
			cost.m(14)
			ingredient = str(gv.Item.CRUMBS)
	
	if inventory[int(ingredient)].greater_equal(cost):
		return "craft " + str(item)
	return "find " + ingredient
