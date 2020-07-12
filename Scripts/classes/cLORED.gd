class_name LORED
extends "res://Scripts/classes/cPurchasable.gd"



var unlocked := false
var active := false
var key_lored := false

var short : String # short name. ex: carcinogens -> carc
var used_by := []

var progress := Num.new()
var task := "no"
var last_task : String
var inhand := Big.new(0)

var level := 1
var d : Num # output; damage, basically
var output_modifier := Big.new()
var f := Num.new() # fuel
var fc := Num.new() # fuel cost
var r := Big.new(0.0) # resources
var b := {} # burn
var cost_modifier := Big.new()
var modifier_from_growin_on_me := Big.new(1.0)
var halt := false
var hold := false
var update_net_text := true
var speed : Num
var crit := Num.new(0.0) # crit chance

# all upgrades that benefit this LORED will go here with the key as the type of benefit.
# benefactors["out"] = up["GEARED OILS"].d * up["BIG TOUGH BOY"].d
var benefactors := {}



func _init(
	_name: String,
	_type: String,
	_burn: Dictionary,
	_cost: Dictionary,
	_speed: float,
	_base_d := 1.0) -> void:
	
	name = _name
	type = _type
	b = _burn
	cost = _cost
	speed = Num.new(_speed)
	d = Num.new(_base_d)



func sync():
	
	f.sync()
	progress.sync()
	
	sync_d()
	sync_fc()
	sync_speed()
	sync_crit()
	sync_cost()
	sync_b()
	
	if r.isLessThan(0):
		r = Big.new(0)
	if r.mantissa < 0:
		r.mantissa = 0
	
	# -
	
	#update_net_text = true


func sync_d():
	
	d.a = Big.new(0)
	d.m = Big.new()
	
	
	# a
	for x in benefactors["add list"]:
		d.a.plus(gv.up[x].d.t)
	
	# m
	for x in benefactors["out list"]:
		d.m.multiply(gv.up[x].d.t)
	
	d.m.multiply(output_modifier)
	d.m.multiply(Big.new(1).max(Big.new(f.f).divide(f.t), 1))
	d.m.multiply(modifier_from_growin_on_me)
	d.m.multiply(gv.hax_pow)
	
	
	d.sync()

func sync_fc():
	
	#fc.a = Big.new(0) - uncomment if you ever need this
	fc.m = Big.new()
	
	
	if gv.up["upgrade_description"].active():
		fc.m.multiply(10)
	
	if "s1" in type and "bur " in type:
		if gv.up["upgrade_name"].active():
			fc.m.multiply(10)
	
	
	fc.sync()

func sync_speed():
	
	#speed.a = Big.new(0)
	speed.m = Big.new()
	
	
	for x in benefactors["haste list"]:
		speed.m.divide(gv.up[x].d.t)
	
	speed.m.divide(gv.hax_pow)
	
	
	speed.sync()

func sync_crit():
	
	crit.a = Big.new(0)
	#crit.m = Big.new()
	
	
	for x in benefactors["crit list"]:
		crit.a.plus(gv.up[x].d.t)
	
	
	crit.sync()

func sync_cost():
	
	for c in cost:
		
		cost[c].m = Big.new()
		
		cost[c].m.multiply(cost_modifier)
		
		for x in benefactors["cost list"]:
			
			if type.split(" ")[0] == gv.up[x].benefactor_of[0]:
				cost[c].m.multiply(gv.up[x].d.t)
				continue
			
			var in_check := false
			var i := -1
			for z in gv.up[x].benefactor_of:
				i += 1
				if not c in gv.up[x].benefactor_of[i]:
					continue
				in_check = true
				break
			
			if not in_check: continue
			
			cost[c].m.multiply(gv.up[x].d.t)
	
	var tier = int(type[1])
	for c in cost:
		
		var vtier = int(gv.g[c].type[1])
		while tier > vtier:
			cost[c].m.multiply(cost_modifier)
			vtier += 1
	
	
	for c in cost:
		
		cost[c].sync()

func sync_b():
	
	for v in b:
		
		#b[v].a = Big.new(0)
		b[v].m = Big.new()
	
		for x in benefactors["burn list"]:
			
			if type.split(" ")[0] == gv.up[x].benefactor_of[0]:
				b[v].m.multiply(gv.up[x].d.t)
				continue
			
			var in_check := false
			var i := -1
			for z in gv.up[x].benefactor_of:
				i += 1
				if not v in gv.up[x].benefactor_of[i]:
					continue
				in_check = true
				break
			
			if not in_check: continue
			
			b[v].m.multiply(gv.up[x].d.t)
	
	for x in b:
		b[x].sync()


func ___________________():
	#lol
	pass


func net(get_raw_power := false, ignore_halt := false) -> Array:
	
	# returns [gain, drain]
	
	var gain = Big.new(d.t).multiply(60).divide(speed.t).multiply(Big.new(1).plus(Big.new(crit.t).divide(10)))
	var drain = Big.new(0)
	
	if not active:
		gain.multiply(0)
	
	# upgrade-specific per_sec bonuses
	if true:
		
		if short == "cop" and gv.up["THE THIRD"].active() and gv.g["copo"].active():
			var gay = Big.new(gv.g["copo"].d.t).multiply(60).divide(gv.g["copo"].speed.t)
			gay.multiply(Big.new(1).plus(Big.new(gv.g["copo"].crit.t).divide(10)))
			gain.plus(gay)
		
		if short == "stone" and gv.up["wait that's not fair"].active() and gv.g["stone"].active():
			var gay = Big.new(gv.g["coal"].d.t).multiply(60).divide(gv.g["coal"].speed.t)
			gay.multiply(Big.new(1).plus(Big.new(gv.g["coal"].crit.t).divide(10)))
			gain.plus(gay)
		
		if short == "iron" and gv.up["I RUN"].active() and not gv.g["iron"].active():
			var gay = Big.new(gv.g["irono"].d.t).multiply(60).divide(gv.g["irono"].speed.t)
			gay.multiply(Big.new(1).plus(Big.new(gv.g["irono"].crit.t).divide(10)))
			gain.plus(gay)
		
		gain.plus(witch(false).multiply(60))
	
	if get_raw_power:
		return [gain, drain]
	
	# halt or hold shit
	if not ignore_halt:
		
		if halt:
			gain.multiply(0)
		
		# all below: candy from babies
		while "bur " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["coal"].level <= 5:
					if f.f.isLessThan(Big.new(f.t).multiply(0.1)):
						gain.multiply(0)
						break
			if f.f.isLessThan(Big.new(f.t).multiply(0.1)) and not gv.g["coal"].active:
				gain.multiply(0)
				break
			break
		
		while "ele " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["jo"].level <= 5:
					if f.f.isLessThan(Big.new(f.t).multiply(0.1)):
						gain.multiply(0)
						break
			if f.f.isLessThan(Big.new(f.t).multiply(0.1)) and not gv.g["jo"].active:
				gain.multiply(0)
				break
			break
		
		for x in b:
			if gv.up["don't take candy from babies"].active():
				if gv.g[x].type[1] == "1" and int(type[1]) > 1 and gv.g[x].level <= 5:
					gain.multiply(0)
					break
			if not gv.g[x].hold: continue
			gain.multiply(0)
			break
	
	# fuel lored
	if short in ["coal", "jo"]:
		
		for x in gv.g:
			
			if not gv.g[x].active:
				continue
			
			if (short == "coal" and "bur " in gv.g[x].type) or (short == "jo" and "ele " in gv.g[x].type):
				if is_baby(int(gv.g[x].type[1])):
					continue
				drain.plus(fuel_lored_net_loss(gv.g[x]))
	
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
		
		var gay = Big.new(gv.g[x].d.t).divide(gv.g[x].speed.t).multiply(60).multiply(gv.g[x].b[short].t)
		drain.plus(gay)
#	if short == "jo":
#		print(gain.toString(), "/", drain.toString())
	return [gain, drain]

func is_baby(gx_type: int = int(type[1])) -> bool:
	
	# compares self and gx.
	# if self is baby and gx is adult, returns true
	
	if int(type[1]) >= 2:
		return false
	
	if not gv.up["don't take candy from babies"].active():
		return false
	
	if level > 5: # f.level
		return false
	
	if gx_type == 1:
		# it is a baby at this point, but
		# babies are allowed to take from other babies
		return false
	
	return true

func fuel_lored_net_loss(gx: LORED) -> float:
	
	var less = Big.new(gx.fc.t).multiply(4)
	var max_fuel = Big.new(gx.f.t).multiply(gv.overcharge) if gx.type[1] in gv.overcharge_list else Big.new(gx.f.t)
	max_fuel.minus(less)
	
	if gx.f.f.isLessThan(Big.new(gx.f.t).minus(less)):
		return Big.new(gx.fc.t).multiply(120).multiply(less_from_full(gx.f.f, max_fuel))
	
	if gx.f.f.isLessThan(max_fuel):
		if gx.halt:
			return Big.new(gx.fc.t).multiply(60).multiply(less_from_full(gx.f.f, max_fuel))
		return Big.new(gx.fc.t).multiply(120).multiply(less_from_full(gx.f.f, max_fuel))
	
	if gx.halt:
		return 0.0
	
	return Big.new(gx.fc.t).multiply(60).multiply(less_from_full(gx.f.f, max_fuel))

func less_from_full(current: Big, _max: Big) -> Big:
	if not gv.up["RELATIVITY"].active():
		return Big.new()
	# if 1% fuel, returns 99x
	# if 60% fuel, returns 40x
	# 1 - (current / max)
	return Big.new(1).minus(Big.new(current).divide(_max)).multiply(100)


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
	
	var witch: Big = Big.new(d.t).multiply(0.01).multiply(speed.b).divide(speed.t)
	
	if gv.up["GRIMOIRE"].active():
		witch.multiply(log(gv.stats.run[0]))
	
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
			taq.task[x].step[key].f.plus(f)
		if taq.task[x].step[key].f.isLargerThan(taq.task[x].step[key].b):
			taq.task[x].step[key].f = Big.new(taq.task[x].step[key].b)
	
	# quest
	if taq.cur_quest != "":
		
		var z = taq.quest.step.keys()[0]
		if z == "Combined resources produced" or (z == "Combined Stage 2 resources produced" and "s2" in type):
			
			if taq.quest.step[z].f.isLessThan(taq.quest.step[z].b):
				taq.quest.step[z].f.plus(f)
			if taq.quest.step[z].f.isLargerThan(taq.quest.step[z].b):
				taq.quest.step[z].f = Big.new(taq.quest.step[z].b)
		
		if not key in taq.quest.step.keys():
			return
		
		if taq.quest.step[key].f.isLessThan(taq.quest.step[key].b):
			taq.quest.step[key].f.plus(f)
		if taq.quest.step[key].f.isLargerThan(taq.quest.step[key].b):
			taq.quest.step[key].f = Big.new(taq.quest.step[key].b)


func w_get_losing() -> float:
	
	var per_sec := 0.0
	
	if short == "coal" or short == "jo":
		for x in gv.g:
			
			if not gv.g[x].active: continue
			
			if (short == "coal" and "bur " in gv.g[x].type) or (short == "jo" and "ele " in gv.g[x].type):
				
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
		per_sec += gv.g[x].d.t / gv.g[x].speed.t * 60 * gv.g[x].b[short].t
	
	return per_sec
