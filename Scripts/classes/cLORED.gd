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
var inhand : float

var level := 1
var d : Num # output; damage, basically
var output_modifier := Num.new()
var f := Num.new() # fuel
var fc := Num.new() # fuel cost
var r: float # resources
var b := {} # burn
var cost_modifier := Num.new()
var modifier_from_growin_on_me := 1.0
var halt := false
var hold := false
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
	_base_d := 1.0
	) -> void:
	
	name = _name
	type = _type
	b = _burn
	cost = _cost
	speed = Num.new(_speed)
	d = Num.new(_base_d)



func sync_self():
	
	f.t = f.b # * w_aa_d("fuelt", f.short)
	output_modifier.t = output_modifier.b * mod("add") * mod("out") * mod_limit_break() * modifier_from_growin_on_me * gv.hax_pow
	d.t = d.b * output_modifier.t
	fc.t = fc.b * mod("fc")
	speed.t = speed.b * mod("haste") / gv.hax_pow
	crit.t = crit.b + mod("crit")

	progress.t = progress.b
	cost_modifier.t = cost_modifier.b
	var tier = int(type[1])
	for v in cost:
		
		cost[v].t = cost[v].b * cost_modifier.t * mod_cost(v)
		
		var vtier = int(gv.g[v].type[1])
		while tier > vtier:
			cost[v].t *= cost_modifier.t
			vtier += 1
	for v in b:
		b[v].t = b[v].b * mod_burn(v)


func mod(_type: String) -> float:
	
	var d := 1.0
	
	match _type:
		"crit":
			d = mod_crit(d - 1)
		"add":
			d = mod_add(d)
		"haste":
			d = mod_haste_d(d)
		"out":
			d = mod_output(d)
		"fc":
			d = mod_fuel_cost(d)
	
	return d

func mod_add(d: float) -> float:
	
	for x in benefactors["add list"]:
		d += gv.up[x].d
	
	return d

func mod_crit(d: float) -> float:
	
	for x in benefactors["crit list"]:
		d += gv.up[x].d
	
	return d

func mod_output(d: float) -> float:
	
	for x in benefactors["out list"]:
		d *= gv.up[x].d
	
	return d

func mod_haste_d(d: float) -> float:
	
	for x in benefactors["haste list"]:
		d *= gv.up[x].d
	
	return d

func mod_limit_break() -> float:
	return max(1.0, f.f / f.t)

func mod_fuel_cost(d: float) -> float:
	
	if gv.up["upgrade_description"].active():
		d *= 10
	
	if "s1" in type and "bur " in type:
		if gv.up["upgrade_name"].active():
			d *= 10
	
	return d

func mod_cost(v: String) -> float:
	
	# v: which key in the cost dictionary
	
	var d := 1.0
	
	for x in benefactors["cost list"]:
		
		if type.split(" ")[0] == gv.up[x].benefactor_of[0]:
			d *= gv.up[x].d
			continue
		
		var in_check := false
		var i := -1
		for z in gv.up[x].benefactor_of:
			i += 1
			if not v in gv.up[x].benefactor_of[i]: continue
			in_check = true
			break
		
		if not in_check: continue
		
		d *= gv.up[x].d
	
	return d

func mod_burn(v: String) -> float:
	
	# v: which key in the cost dictionary
	
	var d := 1.0
	
	for x in benefactors["burn list"]:
		
		if type.split(" ")[0] == gv.up[x].benefactor_of[0]:
			d *= gv.up[x].d
			continue
		
		var in_check := false
		var i := -1
		for z in gv.up[x].benefactor_of:
			i += 1
			if not v in gv.up[x].benefactor_of[i]: continue
			in_check = true
			break
		
		if not in_check: continue
		
		d *= gv.up[x].d
	
	return d


func net(get_raw_power := false, ignore_halt := false) -> float:
	
	var per_sec : float = d.t * 60 / speed.t * (1 + (crit.t / 10))
	
	if not active:
		per_sec = 0.0
	
	# upgrade-specific per_sec bonuses
	if true:
		
		if short == "cop" and gv.up["THE THIRD"].active() and not w_idle("copo"):
			per_sec += gv.g["copo"].d.t * 60 / gv.g["copo"].speed.t * (1 + (gv.g["copo"].crit.t / 10))
		
		if short == "stone" and gv.up["wait that's not fair"].active() and not w_idle("stone"):
			per_sec += gv.g["coal"].d.t * 60 / gv.g["coal"].speed.t * (1 + (gv.g["coal"].crit.t / 10)) * 10
		
		if short == "iron" and gv.up["I RUN"].active() and not w_idle("iron"):
			per_sec += gv.g["irono"].d.t * 60 / gv.g["irono"].speed.t * (1 + (gv.g["irono"].crit.t / 10))
		
		per_sec += witch() * 60
	
	if get_raw_power:
		return per_sec
	
	# halt or hold shit
	if not ignore_halt:
		
		if halt:
			per_sec = 0.0
		
		# all below: candy from babies
		while "bur " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["coal"].level <= 5:
					if f.f < f.t * 0.1:
						per_sec = 0.0
						break
			if f.f < f.t * 0.1 and not gv.g["coal"].active:
				per_sec = 0.0
				break
			break
		
		while "ele " in type:
			if gv.up["don't take candy from babies"].active():
				if int(type[1]) > 1 and gv.g["jo"].level <= 5:
					if f.f < f.t * 0.1:
						per_sec = 0.0
						break
			if f.f < f.t * 0.1 and not gv.g["jo"].active:
				per_sec = 0.0
				break
			break
		
		for x in b:
			if gv.up["don't take candy from babies"].active():
				if gv.g[x].type[1] == "1" and int(type[1]) > 1 and gv.g[x].level <= 5:
					per_sec = 0.0
					break
			if not gv.g[x].hold: continue
			per_sec = 0.0
			break
	
	# fuel lored
	if short == "coal" or short == "jo":
		
		for x in gv.g:
			
			if not gv.g[x].active:
				continue
			
			if (short == "coal" and "bur " in gv.g[x].type) or (short == "jo" and "ele " in gv.g[x].type):
				if is_baby(int(gv.g[x].type[1])):
					continue
				per_sec -= fuel_lored_net_loss(gv.g[x])
	
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
		
		per_sec -= gv.g[x].d.t / gv.g[x].speed.t * 60 * gv.g[x].b[short].t
	
#	if f.short == "coal":
#		print(fval.f(per_sec))
	return per_sec

func is_baby(gx_type: int) -> bool:
	
	# compares f and gx.
	# if f is baby and gx is adult, returns true
	
	if gx_type >= 2:
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
	
	var less = gx.fc.t * 4
	var max_fuel = gx.f.t * gv.overcharge if gx.type[1] in gv.overcharge_list else gx.f.t
	max_fuel -= less
	
	if gx.f.f < gx.f.t - less:
		return gx.fc.t * 120 * less_from_full(gx.f.f, max_fuel)
	
	if gx.f.f < max_fuel:
		if gx.halt:
			return gx.fc.t * 60 * less_from_full(gx.f.f, max_fuel)
		return gx.fc.t * 120 * less_from_full(gx.f.f, max_fuel)
	
	if gx.halt:
		return 0.0
	
	return gx.fc.t * 60 * less_from_full(gx.f.f, max_fuel)

func less_from_full(current: float, _max: float) -> float:
	if not gv.up["RELATIVITY"].active():
		return 1.0
	# if 1% fuel, returns 99x
	# if 60% fuel, returns 40x
	return (1.0 - (current / _max)) * 100


func w_idle(short: String) -> bool:
	# return true if the lored is either halted or inactive
	if not active: return true
	if halt: return true
	return false

func witch() -> float:
	
	if halt or type[1] == "2" or not gv.up["THE WITCH OF LOREDELITH"].active():
		return 0.0
	
	var witch: float = d.t * 0.01 * (speed.b / speed.t)
	
	if gv.w_active("GRIMOIRE"):
		witch *= log(gv.stats.run[0])
	
	task_and_quest_check(witch)
	
	return witch

func task_and_quest_check(f: float) -> void:
	
	var key = name + " produced"
	
	# tasks
	for x in taq.task:
		if not key in taq.task[x].step.keys():
			continue
		#print("key: ", key, " - task step keys: ", taq.task[x].step.keys())
		taq.task[x].step[key].f = min(taq.task[x].step[key].f + f, taq.task[x].step[key].b)
	
	# quest
	if taq.cur_quest != "":
		
		var z = taq.quest.step.keys()[0]
		if z == "Combined resources produced" or (z == "Combined Stage 2 resources produced" and "s2" in type):
			taq.quest.step[z].f = min(taq.quest.step[z].f + f, taq.quest.step[z].b)
		
		if not key in taq.quest.step.keys():
			return
		#print("key: ", key, " - quest step keys: ", taq.quest.step.keys())
		taq.quest.step[key].f = min(taq.quest.step[key].f + f, taq.quest.step[key].b)


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
