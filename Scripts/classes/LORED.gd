class_name LORED
extends "res://Scripts/classes/Purchasable.gd"



var unlocked := false
var active := false
var key_lored := false
var borer := true

var used_by := []

var progress := Float.new()
var task := "no"
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
var speed : Num
var crit := Num.new(0.0) # crit chance

var stage: String
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
	
	name = _name
	key = _key
	type = _type
	
	stage = type[1]
	
	if "ele" in type:
		fuel_source = "jo"
	elif "bur" in type:
		fuel_source = "coal"
	
	if "fur " in type:
		borer = false
	
	b = _burn
	cost = _cost
	speed = Num.new(_speed)
	d = Num.new(_base_d)
	
	color = gv.COLORS[key]
	
	if key in gv.DEFAULT_KEY_LOREDS:
		key_lored = true
	
	if key == "stone":
		active = true
	
	if key in ["stone", "coal"]:
		unlocked = true
	
	# drain
	fc.b = Big.new(0.0015)
	if "s2" in type:
		fc.b.m(10)
	if "fur " in type:
		fc.b.m(1.25)
	
	# fuel
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
	
	
	if gv.r[key].isLessThan(0):
		gv.r[key] = Big.new(0)
	if gv.r[key].mantissa < 0:
		gv.r[key].mantissa = 0.0
	
	if gv.hax_pow != 1:
		d.t.m(gv.hax_pow)
		speed.t.d(gv.hax_pow)

func sync_dynamics() -> void:
	
	for x in dynamics:
		
		if not gv.up[x].active():
			continue
		
		if x == "Limit Break":
			d.lbm = gv.up[x].effects[0].effect.t
		
		match key:
			
			"coal":
				
				d.da = Big.new(0)
				
				match x:
					"I DRINK YOUR MILKSHAKE":
						gv.up[x].effects[0].effect.sync()
						d.da.a(gv.up[x].effects[0].effect.t)
			
			"iron":
				
				d.dm = Big.new(1)
				
				match x:
					"IT'S GROWIN ON ME":
						gv.up[x].effects[0].effect.sync()
						d.dm.m(gv.up[x].effects[0].effect.t)
			
			"cop":
				
				d.dm = Big.new(1)
				
				match x:
					"IT'S GROWIN ON ME":
						gv.up[x].effects[1].effect.sync()
						d.dm.m(gv.up[x].effects[1].effect.t)
			
			"irono":
				
				d.dm = Big.new(1)
				
				match x:
					"IT'S SPREADIN ON ME":
						gv.up[x].effects[0].effect.sync()
						d.dm.m(gv.up[x].effects[0].effect.t)
			
			"copo":
				
				d.dm = Big.new(1)
				
				match x:
					"IT'S SPREADIN ON ME":
						gv.up[x].effects[1].effect.sync()
						d.dm.m(gv.up[x].effects[1].effect.t)


func net(get_raw_power := false, ignore_halt := false) -> Array:
	
	# returns [gain, drain]
	
	var gain = Big.new(d.t).m(60).d(speed.t).m(Big.new(1).a(crit.t.percent(10)))
	var drain = Big.new(0)
	
	if not active:
		gain.m(0)
	
	# upgrade-specific per_sec bonuses
	if true:
		
		if key == "cop" and gv.up["THE THIRD"].active() and gv.g["copo"].active():
			var gay = Big.new(gv.g["copo"].d.t).m(60).d(gv.g["copo"].speed.t)
			gay.m(Big.new(1).a(Big.new(gv.g["copo"].crit.t).d(10)))
			gain.a(gay)
		
		if key == "stone" and gv.up["wait that's not fair"].active() and gv.g["stone"].active():
			var gay = Big.new(gv.g["coal"].d.t).m(60).d(gv.g["coal"].speed.t)
			gay.m(Big.new(1).a(Big.new(gv.g["coal"].crit.t).d(10)))
			gain.a(gay)
		
		if key == "iron" and gv.up["I RUN"].active() and not gv.g["iron"].active():
			var gay = Big.new(gv.g["irono"].d.t).m(60).d(gv.g["irono"].speed.t)
			gay.m(Big.new(1).a(Big.new(gv.g["irono"].crit.t).d(10)))
			gain.a(gay)
		
		if active:
			gain.a(witch(false).m(60))
	
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
					if f.f.isLessThan(Big.new(f.t).m(0.1)):
						gain.m(0)
						break
			if f.f.isLessThan(Big.new(f.t).m(0.1)) and not gv.g["coal"].active:
				gain.m(0)
				break
			break
		
		while "ele " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["jo"].level <= 5:
					if f.f.isLessThan(Big.new(f.t).m(0.1)):
						gain.m(0)
						break
			if f.f.isLessThan(Big.new(f.t).m(0.1)) and not gv.g["jo"].active:
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
		
		var gay = Big.new(gv.g[x].d.t).d(gv.g[x].speed.t).m(60).m(gv.g[x].b[key].t)
		drain.a(gay)
	
	if drain.exponent < -10:
		drain.mantissa = 0.0
		drain.exponent = 0
	
	return [gain, drain]


func bought():
	
	# price
	if true:
		
		for c in cost:
			gv.r[c].s(cost[c].t)
			gv.emit_signal("lored_updated", c, "amount")
		
		increase_cost()
	
	# task stuff
	if taq.cur_quest != "":
		
		match key:
			"coal":
				if "Coal LORED bought" in taq.quest.step:
					taq.quest.step["Coal LORED bought"].f = Big.new()
						
			"stone":
				if "Stone LORED bought" in taq.quest.step:
					taq.quest.step["Stone LORED bought"].f = Big.new()
			"iron":
				if "Iron LORED bought" in taq.quest.step:
					taq.quest.step["Iron LORED bought"].f = Big.new()
			"cop":
				if "Copper LORED bought" in taq.quest.step:
					taq.quest.step["Copper LORED bought"].f = Big.new()
	
	gv.emit_signal("lored_updated", key, "d")
	
	# already owned; upgrading
	if active:
		
		level += 1
		d.m.m(2)
		fc.m.m(2)
		f.m.m(2)
		
		sync()
		
		if key == "coal" and f.f.isLessThan(Big.new(speed.t).m(fc.t).m(2)):
			f.f.a(Big.new(speed.t).m(fc.t).m(2))
		
		gv.emit_signal("lored_updated", key, "buy modulate")
		
		for x in b:
			gv.emit_signal("lored_updated", x, "net")
		
		return
	
	# not owned
	if true:
		
		active = true
		unlocked = true
		
		if not gv.s2_upgrades_may_be_autobought:
			if key in gv.loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
				gv.check_for_the_s2_shit()
		
		gv.emit_signal("lored_updated", key, "buy modulate")

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
	
	if gx.f.f.isLessThan(Big.new(gx.f.t).s(less)):
		if gx.halt:
			return Big.new(gx.fc.t).m(60)
		return Big.new(gx.fc.t).m(120)
	
	if gx.halt:
		return Big.new(0)
	
	return Big.new(gx.fc.t).m(60)


func active() -> bool:
	# return true if the lored is either halted or inactive
	if not active: return false
	if halt: return false
	return true

func witch(produced : bool) -> Big:
	
	if halt or type[1] == "2" or not gv.up["THE WITCH OF LOREDELITH"].active():
		return Big.new(0.0)
	if "no" in gv.menu.f:
		return Big.new(0)
	
	var witch: Big = Big.new(d.t).m(0.01).m(speed.b.percent(speed.t))
	
	if gv.up["GRIMOIRE"].active():
		witch.m(log(gv.stats.run[0]))
	
	if not produced:
		return witch
	
	task_and_quest_check(witch)
	
	return witch

func task_and_quest_check(f: Big) -> void:
	
	var key = name + " produced"
	
	# tasks
	for x in taq.task:
		
		if not key in taq.task[x].step.keys():
			continue
		
		if taq.task[x].step[key].f.isLessThan(taq.task[x].step[key].b):
			taq.task[x].step[key].f.a(f)
		if taq.task[x].step[key].f.isLargerThan(taq.task[x].step[key].b):
			taq.task[x].step[key].f = Big.new(taq.task[x].step[key].b)
	
	# quest
	if taq.cur_quest != "":
		
		var z = taq.quest.step.keys()[0]
		if z == "Combined resources produced" or (z == "Combined Stage 2 resources produced" and "s2" in type):
			
			if taq.quest.step[z].f.isLessThan(taq.quest.step[z].b):
				taq.quest.step[z].f.a(f)
			if taq.quest.step[z].f.isLargerThan(taq.quest.step[z].b):
				taq.quest.step[z].f = Big.new(taq.quest.step[z].b)
		
		if not key in taq.quest.step.keys():
			return
		
		if taq.quest.step[key].f.isLessThan(taq.quest.step[key].b):
			taq.quest.step[key].f.a(f)
		if taq.quest.step[key].f.isLargerThan(taq.quest.step[key].b):
			taq.quest.step[key].f = Big.new(taq.quest.step[key].b)


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
						if not gv.g[x].halt: per_sec += gv.g[x].fc.t * 60
	
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
		per_sec += gv.g[x].d.t / gv.g[x].speed.t * 60 * gv.g[x].b[key].t
	
	return per_sec



func autobuy() -> bool:
	
	if not autobuy:
		return false
	
	if not active:
		return true
	
	if halt:
		return false
	
	# low fuel
	if true:
		
		var minimum_fuel = Big.new(fc.t).m(2)
		
		if f.f.isLessThan(minimum_fuel):
			return false
	
	if autobuy_upgrade_check():
		return true
	
	# if ingredient LORED per_sec < per_sec, don't buy
	for x in b:
		
		if gv.g[x].hold:
			return false
		
		var consm = Big.new(b[x].t).m(60).m(d.t.percent(speed.t))
		# how much this lored consumes from the ingredient lored (x)
		
		if gv.g[x].halt:
			
			var consm2 = Big.new(consm).m(2)
			if consm2.isLessThan(gv.g[x].net(true)[0]):
				if not gv.g[x].cost_check():
					return false
		
		else:
			
			var net = gv.g[x].net()
			
			if net[0].isLessThan(net[1]):
				return false
			
			net = Big.new(net[0]).s(net[1])
			if consm.isLargerThan(net):
				if not gv.g[x].cost_check():
					return false
	
	if key_lored:
		return true
	
	var net = net()
	if net[0].isLargerThan(net[1]):
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
	
	inhand = Big.new(0)
	progress.f = 0.0
	progress.b = 1.0
	progress.sync()
	
	sync()

func partial_reset():
	
	d.m = Big.new()
	fc.m = Big.new()
	f.m = Big.new()
	
	for c in cost:
		cost[c].m = Big.new()
	sync_cost()
	
	halfway_reset_stuff()
	
	gv.emit_signal("lored_updated", key, "net")
	gv.emit_signal("lored_updated", key, "d")
