class_name Task
extends Reference


var key: int # used for quests
var name: String

var random := false
var complete := false
var ready := false
var selectable := false
var repeatable := false
var can_quit := false

var desc := ""
var reward := []
var req := [] # requirements
var reqs_done := 0
var icon: Texture
var icon_key: String
var color := Color(0,0,0)
var color_key := ""
var points := Big.new(0)
var total_points := Big.new(1) # only used for visual things

var manager: MarginContainer

var times_completed: int

class Reward:
	
	var type: int
	
	var text: String
	var icon: Texture
	var icon_key: String
	var color: Color
	var amount: Big
	var other_key: String
	var other_keys: Array
	
	func _init(_type: int, _text: String, _icon: String, other := {}):
		
		type = _type
		text = _text
		icon_key = _icon
		icon = gv.sprite[_icon]
		
		if icon_key in gv.COLORS.keys():
			color = gv.COLORS[icon_key]
		else:
			color = gv.COLORS["grey"]
		
		other_keys = other.keys()
		
		if "other_key" in other.keys():
			other_key = other["other_key"]
		if "amount" in other.keys():
			amount = Big.new(other["amount"])

class Requirement:
	
	var type: int
	
	var req_key: String
	var icon_key: String
	var text: String
	var icon: Texture
	var amount: Big = Big.new(1)
	var progress: Big = Big.new(0)
	var done := false
	var deet_keys: Array
	
	var color: Color
	
	func _init(_type: int, _icon_key: String, deets: Dictionary) -> void:#quest_key: int, index := 0, times_completed := 0) -> void:
		
		# deets should have keys like ["amount", "req_key"]
		
		type = _type
		icon_key = _icon_key
		icon = gv.sprite[icon_key]
		deet_keys = deets.keys()
		
		if "req_key" in deets.keys():
			req_key = deets["req_key"]
			if req_key in gv.COLORS.keys():
				color = gv.COLORS[req_key]
			else:
				color = gv.COLORS["grey"]
		else:
			color = gv.COLORS["grey"]
		
		if "amount" in deets.keys():
			amount = Big.new(deets["amount"])
		
		if type == gv.TaskRequirement.UPGRADE_PURCHASED:
			if gv.up[req_key].have:
				done = true
		
		match type:
			gv.TaskRequirement.RESOURCE_PRODUCTION:
				if req_key == "any":
					text = "Combined resources produced"
				else:
					if req_key in gv.g.keys():
						text = gv.g[req_key].name + " produced"
					else:
						text = req_key.capitalize() + " produced"
			gv.TaskRequirement.SPELL_CAST:
				text = req_key + " cast"
			gv.TaskRequirement.RARE_OR_SPIKE_TASKS_COMPLETED:
				text = "Rare or spike tasks completed"
			gv.TaskRequirement.TASKS_COMPLETED:
				text = "Tasks completed"
			gv.TaskRequirement.UPGRADE_PURCHASED:
				text = req_key + " purchased"
			gv.TaskRequirement.LORED_UPGRADED:
				text = gv.g[req_key].name + " LORED upgraded"
			gv.TaskRequirement.UPGRADES_PURCHASED:
				text = "%s upgrades purchased" % {"s1n": "Normal", "s1m": "Malignant", "s2n": "Extra-normal", "s2m": "Radiative", "s3n": "Runed Dial", "s3m": "Spirit"}[req_key]
	
	func _progress(incoming_key: String, val: Big) -> Big:
		
		# if should increase reqs_done by 1, returns true
		
		if done:
			return Big.new(0)
		
		if incoming_key != req_key:
			if req_key != "any":
				return Big.new(0)
		
		progress.a(val)
		
		if progress.greater(amount):
			progress = Big.new(amount)
			val.s(Big.new(progress).s(amount))
		
		if progress.equal(amount):
			done = true
		
		return val
	
	func reset():
		
		done = false
		
		if "amount" in deet_keys:
			progress = Big.new(0)

func check_already_complete() -> void:
	
	for r in req:
		if r.type == gv.TaskRequirement.UPGRADE_PURCHASED:
			if gv.up[r.req_key].have:
				progress(r.type, r.req_key)
	
	check_for_completion(false)

func progress(req_type: int, incoming_key: String, val := Big.new(1)) -> void:
	
	var at_least_one := false
	
	for r in req:
		if r.done:
			continue
		if req_type == r.type or (r.type == gv.TaskRequirement.TASKS_COMPLETED and req_type == gv.TaskRequirement.RARE_OR_SPIKE_TASKS_COMPLETED):
			at_least_one = true
			points.a(r._progress(incoming_key, val))
			if r.done:
				reqs_done += 1
	
	if not at_least_one:
		return
	
	update_points()
	check_for_completion(false)

func set_total_points():
	
	total_points = Big.new(0)
	
	for r in req:
		total_points.a(r.amount)

func update_points():
	
	if points.greater(total_points):
		points = Big.new(total_points)
	
	manager.r_update()

func attempt_turn_in(manual: bool):
	
	check_for_completion(manual)
	
	if ready:
		turn_in(manual)
		return
	
	if manual:
		if random:
			if is_instance_valid(manager.rt.get_node("global_tip").tip):
				manager.rt.get_node("global_tip").tip.cont["taq"].flash()
		else:
			if is_instance_valid(manager.rt.get_node("global_tip").tip):
				manager.rt.get_node("global_tip").tip.cont["taq"].flash()

func check_for_completion(manual: bool) -> void:
	
	if ready:
		return
	
	if reqs_done >= req.size():
		ready()
		if random and gv.menu.option["task auto"]:
			turn_in(manual)

func ready():
	
	if not random:
		print("ready!")
	ready = true
	manager.ready()


#func _generate_random_task() -> Task:
#
#	var roll : int = 0#rand_range(0, 2)
#	var type : String
#	var key: String
#
#	match roll:
#		0:
#			type = "collect"
#
#	# difficulty of step
#	var rall : float = rand_range(20,200) # 20-199
#	var rarity_roll :float=rand_range(0,100) if gv.stats.tasks_completed > 15 else 10.0
#
#	# which LORED is the step messing with
#	while true:
#
#		key = gv.g.keys()[randi() % gv.g.size()]
#
#		if not gv.g[key].unlocked:
#			continue
#		if not gv.g[key].active:
#			continue
#		if key == "growth" and not gv.g["jo"].active:
#			continue
#		if gv.g[key].stage == "3":
#			continue
#
#		var cont := false
#		for x in gv.g[key].b:
#			if not gv.g[x].active:
#				cont = true
#				break
#
#		if cont:
#			continue
#
#		for x in gv.g[key].b:
#
#			if "no" in gv.menuf:
#				if int(gv.g[x].type[1]) <= int(gv.menuf.split("no s")[1]):
#					cont = true
#					break
#
#			if not gv.g[x].active:
#				cont = true
#				break
#
#		if cont:
#			continue
#
#		if "2" == gv.g[key].type[1] and gv.stats.run[1] == 1:
#			rall *= 0.1
#		break
#
#	var name : String
#	var desc : String
#	var rr := {}
#	var r := {}
#	var step := {}
#	var icon := {texture = gv.sprite["unknown"], key = "unknown"}
#
#	var rr_size := 1
#	if rarity_roll >= 0.1:
#		roll = rand_range(0, 100)
#		if roll > 95: rr_size = 4
#		elif roll > 85: rr_size = 3
#		elif roll > 50: rr_size = 2
#		else: rr_size = 1
#
#	var time := Big.new(0)
#
#	# name / desc / step / icon
#	if true:
#
#		# icon
#		icon.key = key
#		icon.texture = gv.sprite[key]
#
#		# name
#		while true:
#
#			name = generate_task_name(key)
#
#			if rarity_roll <= 0.1:
#				name = name + " {Spike}"
#			elif rarity_roll <= 5:
#				name = name + " (Rare)"
#
#			if not name in content.keys():
#				break
#
#		# desc / step
#		match type:
#			"collect":
#
#				var net = Big.new(gv.g[key].net(true)[0])
#
#				var amount: Big = Big.new(rall).m(Big.new(Big.max(gv.g[key].d.b, net))).m(rr_size)
#
#				step[key + " produced"] = Ob.Num.new(amount)
#				time.a(amount).d(60)
#				time.d(Big.new(Big.max(net, 0.05)))
#				desc = "Collect " + gv.g[key].name + "."
#
#	# resource_reward
#	if true:
#
#		for x in rr_size:
#
#			# spike task only
#			if "{Spike}" in name:
#				var gg = "malig"
#				match gv.stats.highest_run:
#					2:
#						gg = "tum"
#				var reward = Big.new(Big.max(gv.stats.most_resources_gained, gv.stats.run[gv.stats.highest_run - 1] * 1000))
#				var cawk = Big.new(gv.g[gg].net(true)[0]).m(21600)
#				if reward.less(cawk):
#					reward.a(cawk)
#				reward.m(rand_range(0.9, 1.1))
#				rr[gg] = reward
#
#			else:
#
#				var _key = ""
#				var blacklist = ["plast", "jo", "coal", "irono", "copo", "oil", "tar", "growth", "draw", "humus", "sand", "gale", "pulp", "paper", "soil", "toba", "tree"]
#
#				while true:
#
#					_key = gv.g.keys()[randi() % gv.g.size()]
#
#					if rarity_roll < 5:
#						if _key in blacklist:
#							continue
#					if _key == "growth" and not gv.g["jo"].active:
#						continue
#					if _key in ["malig", "tum"]:
#						if gv.stats.run[int(gv.g[_key].type[1])] == 1:
#							continue
#					if gv.g[_key].stage == "3":
#						continue
#					if not gv.g[_key].unlocked:
#						continue
#
#					var cont := false
#					for v in gv.g[_key].b:
#						if "no" in gv.menuf:
#							var menu = gv.menuf.split("no ")[1]
#							if menu in gv.g[v].type:
#								cont = true
#								break
#						if gv.g[v].active: continue
#						if gv.stats.run[int(gv.g[v].type[1]) - 1] == 1: continue
#						cont = true
#						break
#
#					if cont:
#						continue
#
#					break
#
#				var progression_mod :float= gv.stats.tasks_completed / 10
#				if progression_mod < 1: progression_mod = 1.0
#				if progression_mod > 100: progression_mod = 100.0
#				var quest_mod = 10.0 if rt.quests["Horse Doodie"].complete else 1.0
#
#				var dink: Big = Big.new(gv.g[_key].net(true)[0]).m(progression_mod).m(time).m(quest_mod)
#				if "(Rare)" in name: dink.m(rand_range(1.0, 3.0))
#
#				#dink *= 1 + time
#
#				if gv.stats.tasks_completed < 10:
#					dink.m(4)
#				if gv.stats.tasks_completed < 20:
#					dink.m(2)
#				if gv.stats.tasks_completed < 30:
#					dink.m(1.5)
#				if gv.stats.tasks_completed < 40:
#					dink.m(1.25)
#
#				var reward: Big = Big.new(dink).m(rand_range(0.9,1.1))
#
#				if reward.less(1):
#					reward.mantissa = 1.0
#				elif reward.exponent < 2:
#					reward.mantissa = round(reward.mantissa)
#
#
#				if _key in rr.keys():
#					rr[_key].a(reward)
#				else:
#					rr[_key] = reward
#
#	var _task = Task.new(name, desc, rr, r, step, icon, gv.g[key].color)
#
#	_task.code = stepify(rand_range(0,100.0), .01)
#	while _task.code in content.keys():
#		_task.code = stepify(rand_range(0,100.0), .01)
#
#	return _task
func _init(_key: int, pack := {}) -> void:
	
	key = _key
	
	if pack.size() > 0:
		
		name = pack["name"]
		icon_key = pack["icon_key"]
		icon = gv.sprite[icon_key]
		reward = pack["reward"]
		req = pack["reqs"]
		
		for r in req:
			total_points.a(r.amount)
			points.a(r.progress)
		
		match key:
			gv.Quest.RANDOM_COMMON:
				color_key = "common"
			gv.Quest.RANDOM_RARE:
				color_key = "rare"
			gv.Quest.RANDOM_SPIKE:
				color_key = "spike"
		
		color = gv.COLORS[color_key]
		
		random = true
		
		return
	
	match key:
		
		gv.Quest.WITCH, gv.Quest.NECRO, gv.Quest.BLOOD, gv.Quest.HUNT:
			
			match key:
				gv.Quest.WITCH:
					icon_key = "witch"
				gv.Quest.NECRO:
					icon_key = "necro"
				gv.Quest.BLOOD:
					icon_key = "blood"
				gv.Quest.HUNT:
					icon_key = "hunt"
			
			name = icon_key.capitalize()
			
			selectable = true
			repeatable = true
			can_quit = true
		
		gv.Quest.RANDOM:
			
			random = true
			
			var roll: float = rand_range(0, 100)
			var difficulty = rand_range(20,80)
			var reward_mod = difficulty / 3
			
			difficulty /= gv.hax_pow
			
			if gv.stats.tasks_completed <= 20:
				roll = 10
				difficulty /= (3 - (gv.stats.tasks_completed * 0.1))
				reward_mod /= (3 - (gv.stats.tasks_completed * 0.1))
			if gv.quest[gv.Quest.HORSE_DOODIE].complete:
				difficulty /= 10
				reward_mod *= 10
			
			if roll < 0.1 and gv.stats.run[0] > 1:
				key = gv.Quest.RANDOM_SPIKE
				difficulty *= 1000
				color_key = "spike"
			elif roll < 5:
				key = gv.Quest.RANDOM_RARE
				difficulty *= 10
				reward_mod *= 25
				color_key = "rare"
			else:
				key = gv.Quest.RANDOM_COMMON
				color_key = "common"
			
			var reward_size := 1
			# warnings-disable
			var active_rare_list: Array
			if not key == gv.Quest.RANDOM_SPIKE:
				if roll >= 0.1:
					roll = rand_range(0, 100)
					if roll > 95: reward_size = 4
					elif roll > 85: reward_size = 3
					elif roll > 50: reward_size = 2
				
				for x in gv.stats.g_list["rare quest whitelist"]:
					if gv.g[x].active:
						active_rare_list.append(x)
				if active_rare_list.size() < reward_size:
					reward_size = active_rare_list.size()
			
			difficulty *= reward_size
			
			# selecting a resource to collect
			var s1s2keys = gv.stats.g_list["active s1"] + gv.stats.g_list["active s2"]
			var req_key: String = s1s2keys[randi() % s1s2keys.size()]
			while not gv.g[req_key].can_work():
				req_key = s1s2keys[randi() % s1s2keys.size()]
			
			difficulty /= gv.g[req_key].speed.t
			reward_mod /= gv.g[req_key].speed.t
			
			# req
			var amount: Big = Big.new(difficulty).m(gv.g[req_key].d.t)
			if amount.less(1):
				amount = Big.new(1)
			if gv.g[req_key].stage == "2" and gv.stats.run[1] == 1:
				amount.d(10)
			amount.mantissa = floor(amount.mantissa)
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, req_key, {"amount": amount.toScientific(), "req_key": req_key}))
			
			name = taq.generate_task_name(req_key)
			icon_key = req_key
			
			match key:
				
				gv.Quest.RANDOM_SPIKE:
					var gg = "malig"
					match gv.stats.highest_run:
						2:
							gg = "tum"
					var _reward = Big.new(Big.max(Big.max(gv.stats.most_resources_gained, Big.new(gv.r[gg]).m(10)), gv.stats.run[gv.stats.highest_run - 1]))
					var cawk = Big.new(gv.g[gg].net(true)[0]).m(21600)
					if _reward.less(cawk):
						_reward.a(cawk)
					_reward.m(rand_range(0.9, 1.1))
					_reward.mantissa = floor(_reward.mantissa)
					
					reward.append(Reward.new(gv.QuestReward.RESOURCE, gv.g[gg].name, gg, {"other_key": gg, "amount": _reward.toScientific()}))
				
				_:
					
					var reward_keys := []
					
					for r in reward_size:
						
						var rare_list = active_rare_list
						var common_list = gv.stats.g_list["s1"] + gv.stats.g_list["s2"]
						
						var applicant: String
						
						while true:
							
							if key == gv.Quest.RANDOM_RARE:
								applicant = rare_list[randi() % rare_list.size()]
							else:
								applicant = common_list[randi() % common_list.size()]
							
							if not gv.g[applicant].unlocked:
								continue
							if applicant in reward_keys:
								continue
							if applicant == "growth" and not gv.g["jo"].active:
								continue
							if applicant in ["malig", "tum"]:
								if gv.stats.run[int(gv.g[applicant].type[1])] == 1:
									continue
							if not gv.g[applicant].unlocked:
								continue
							
							var cont := false
							for v in gv.g[applicant].b:
								if gv.g[v].active: continue
								if gv.stats.run[int(gv.g[v].type[1]) - 1] == 1: continue
								cont = true
								break
							if cont:
								continue
							
							reward_keys.append(applicant)
							
							if key == gv.Quest.RANDOM_RARE:
								rare_list.erase(applicant)
							else:
								common_list.erase(applicant)
							
							break
					
					for r in reward_keys:
						var _reward = Big.max(Big.new(reward_mod).m(rand_range(0.8,1.2)).m(Big.max(gv.g[r].net(true)[0], 1)), 1.0)
						if _reward.less(1):
							_reward = Big.new(1)
						_reward.mantissa = floor(_reward.mantissa)
						reward.append(Reward.new(gv.QuestReward.RESOURCE, gv.g[r].name, r, {"other_key": r, "amount": _reward.toScientific()}))
		
		gv.Quest.INTRO:
			
			name = "Intro!"
			desc = "Your Stone LORED requires fuel to work. Buy a Coal LORED with the Stone you already have."
			icon_key = "coal"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "10"}))
			
			req.append(Requirement.new(gv.TaskRequirement.LORED_UPGRADED, "coal", {"req_key": "coal"}))
		
		gv.Quest.MORE_INTRO:
			
			name = "More Intro!"
			icon_key = "stone"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "20"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "20"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "10"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Iron Ore", "irono", {"other_key": "irono"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Copper Ore", "copo", {"other_key": "copo"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Iron", "iron", {"other_key": "iron"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Copper", "cop", {"other_key": "cop"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "stone", {"amount": "10", "req_key": "stone"}))
		
		gv.Quest.WELCOME_TO_LORED:
			
			name = "Welcome to LORED"
			desc = "Upgrading LOREDs doubles their output and fuel burnt per tick."
			icon_key = "stone"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Coal", "coal", {"other_key": "coal", "amount": "30"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "30"}))
			reward.append(Reward.new(gv.QuestReward.UPGRADE_MENU, "Normal Upgrade Menu", "s1n", {"other_key": "s1n"}))
			
			req.append(Requirement.new(gv.TaskRequirement.LORED_UPGRADED, "stone", {"req_key": "stone"}))
		
		gv.Quest.UPGRADES:
			
			name = "Upgrades!"
			desc = "Purchase the GRINDER upgrade in the Normal Upgrades menu. (Hotkey: ` or Q)"
			icon_key = "s1n"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "30"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "30"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "30"}))
			reward.append(Reward.new(gv.QuestReward.OTHER, "Task Board", "copy"))
			reward.append(Reward.new(gv.QuestReward.MAX_TASKS, "Max tasks +1", "copy"))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADE_PURCHASED, gv.up["GRINDER"].icon, {"req_key": "GRINDER"}))
		
		gv.Quest.TASKS:
			
			name = "Tasks!"
			desc = "Tasks are randomized, mini-quests. Upgrading LOREDs mid-task does not increase the amount required for the task."
			icon_key = "copy"
			
			reward.append(Reward.new(gv.QuestReward.MAX_TASKS, "Max tasks +1", "copy"))
			
			req.append(Requirement.new(gv.TaskRequirement.TASKS_COMPLETED, "copy", {"amount": "3"}))
		
		gv.Quest.PRETTY_WET:
			
			name = "Pretty Wet"
			icon_key = "growth"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "100"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "100"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Growth", "growth", {"other_key": "growth"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "stone", {"amount": "1000", "req_key": "stone"}))
		
		gv.Quest.PROGRESS:
			
			name = "Progress"
			icon_key = "cop"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "100"}))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADE_PURCHASED, gv.up["RYE"].icon, {"req_key": "RYE"}))
		
		gv.Quest.ELECTRICY:
			
			name = "Electricy"
			desc = "Some LOREDs run on electricity instead of Coal!"
			icon_key = "jo"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "250"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "250"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Concrete", "conc", {"other_key": "conc"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Joules", "jo", {"other_key": "jo"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "s1", {"amount": "10000", "req_key": "any"}))
		
		gv.Quest.SANDY_PROGRESS:
			
			name = "Sandy Progress"
			icon_key = "growth"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "1000"}))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADE_PURCHASED, gv.up["SAND"].icon, {"req_key": "SAND"}))
		
		gv.Quest.SPREAD:
			
			name = "Spread"
			icon_key = "malig"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "1000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "1000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Malignancy", "malig", {"other_key": "malig", "amount": "10"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Oil", "oil", {"other_key": "oil"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Tarballs", "tar", {"other_key": "tar"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Malignancy", "malig", {"other_key": "malig"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "s1", {"amount": "100000", "req_key": "any"}))
		
		gv.Quest.LOTS_OF_TASKS:
			
			name = "Lots of Tasks!"
			icon_key = "copy"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "1000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "1000"}))
			reward.append(Reward.new(gv.QuestReward.MAX_TASKS, "Max tasks +1", "copy"))
			
			req.append(Requirement.new(gv.TaskRequirement.TASKS_COMPLETED, "copy", {"amount": "10"}))
		
		gv.Quest.CONSUME:
			
			name = "Consume"
			icon_key = "malig"
			
			reward.append(Reward.new(gv.QuestReward.UPGRADE_MENU, "Malignant Upgrade Menu", "s1m", {"other_key": "s1m"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "malig", {"amount": "3000", "req_key": "malig"}))
		
		gv.Quest.EVOLVE:
			
			name = "Evolve"
			desc = "Select which Malignant upgrades you want, and then Metastasize to activate them!"
			icon_key = "s1"
			color_key = "malig"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Malignancy", "malig", {"other_key": "malig", "amount": "1000"}))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADE_PURCHASED, gv.up["SOCCER DUDE"].icon, {"req_key": "SOCCER DUDE"}))
		
		gv.Quest.A_MILLION_REASONS_TO_GRIND:
			
			name = "A Million Reasons to Grind"
			desc = "Hit SPACE, ENTER, or NUM PAD ENTER to turn in all tasks."
			icon_key = "copy"
			color_key = "rare"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Iron", "iron", {"other_key": "iron", "amount": "100000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Copper", "cop", {"other_key": "cop", "amount": "100000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Stone", "stone", {"other_key": "stone", "amount": "199999"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Growth", "growth", {"other_key": "growth", "amount": "600001"}))
			reward.append(Reward.new(gv.QuestReward.MAX_TASKS, "Max tasks +1", "copy"))
			
			req.append(Requirement.new(gv.TaskRequirement.TASKS_COMPLETED, "copy", {"amount": "50"}))
		
		gv.Quest.THE_LOOP:
			
			name = "The Loop"
			icon_key = "s1"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Concrete", "conc", {"other_key": "conc", "amount": "1e9"}))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADE_PURCHASED, gv.up["upgrade_name"].icon, {"req_key": "upgrade_name"}))
		
		gv.Quest.A_NEW_LEAF:
			
			name = "A New Leaf"
			desc = "Advances your existence to a Stage 2 presence."
			icon_key = "s2"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Seeds", "seed", {"other_key": "seed", "amount": "2"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Soil", "soil", {"other_key": "soil", "amount": "25"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Wood", "wood", {"other_key": "wood", "amount": "80"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Trees", "tree", {"other_key": "tree"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Water", "water", {"other_key": "water"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Seeds", "seed", {"other_key": "seed"}))
			reward.append(Reward.new(gv.QuestReward.STAGE, "Stage 1", "s1", {"other_key": "1"}))
			reward.append(Reward.new(gv.QuestReward.STAGE, "Stage 2", "s2", {"other_key": "2"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "s2", {"amount": "1e9", "req_key": "any"}))
		
		gv.Quest.STEEL_PATTERN:
			
			name = "Steel Pattern"
			icon_key = "steel"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Hardwood", "hard", {"other_key": "hard", "amount": "95"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Steel", "steel", {"other_key": "steel", "amount": "25"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Liquid Iron", "liq", {"other_key": "liq"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Steel", "steel", {"other_key": "steel"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "tree", {"amount": "5", "req_key": "tree"}))
		
		gv.Quest.WIRE_TRAIL:
			
			name = "Wire Trail"
			icon_key = "wire"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Wire", "wire", {"other_key": "wire", "amount": "20"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Glass", "glass", {"other_key": "glass", "amount": "30"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Wire", "wire", {"other_key": "wire"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Draw Plate", "draw", {"other_key": "draw"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "steel", {"amount": "5", "req_key": "steel"}))
		
		gv.Quest.HARDWOOD_CYCLE:
			
			name = "Hardwood Cycle"
			icon_key = "hard"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Liquid Iron", "liq", {"other_key": "liq", "amount": "100"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Axes", "axe", {"other_key": "axe", "amount": "5"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Wood", "wood", {"other_key": "wood"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Axes", "axe", {"other_key": "axe"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Hardwood", "hard", {"other_key": "hard"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "wire", {"amount": "50", "req_key": "wire"}))
		
		gv.Quest.GLASS_PASS:
			
			name = "Glass Pass"
			icon_key = "glass"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Steel", "steel", {"other_key": "steel", "amount": "50"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Sand", "sand", {"other_key": "sand", "amount": "250"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Glass", "glass", {"other_key": "glass"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Sand", "sand", {"other_key": "sand"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Humus", "humus", {"other_key": "humus"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Soil", "soil", {"other_key": "soil"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "hard", {"amount": "50", "req_key": "hard"}))
		
		gv.Quest.THE_HEART_OF_THINGS:
			
			name = "The Heart of Things"
			icon_key = "tum"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Steel", "steel", {"other_key": "steel", "amount": "50"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Hardwood", "hard", {"other_key": "hard", "amount": "50"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Wire", "wire", {"other_key": "wire", "amount": "50"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Glass", "glass", {"other_key": "glass", "amount": "50"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Tumors", "tum", {"other_key": "tum"}))
			reward.append(Reward.new(gv.QuestReward.UPGRADE_MENU, "Extra-normal Upgrade Menu", "s2n", {"other_key": "s2n"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "soil", {"amount": "25", "req_key": "soil"}))
		
		gv.Quest.SPIKE:
			
			name = "Spike"
			desc = "Rare and Spike tasks take longer than regular tasks, but they reward a lot more stuff!"
			icon_key = "copy"
			color_key = "rare"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Wood", "wood", {"other_key": "wood", "amount": "10000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Water", "water", {"other_key": "water", "amount": "20000"}))
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Liquid Iron", "liq", {"other_key": "liq", "amount": "30000"}))
			reward.append(Reward.new(gv.QuestReward.OTHER, "Tasks are automatically turned in", "copy"))
			
			req.append(Requirement.new(gv.TaskRequirement.RARE_OR_SPIKE_TASKS_COMPLETED, "copy", {"amount": "3"}))
		
		gv.Quest.LEAD_BY_EXAMPLE:
			
			name = "Lead by Example"
			icon_key = "tum"
			
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Galena", "gale", {"other_key": "gale"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Lead", "lead", {"other_key": "lead"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "hard", {"amount": "200", "req_key": "hard"}))
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "wire", {"amount": "200", "req_key": "wire"}))
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "glass", {"amount": "200", "req_key": "glass"}))
		
		gv.Quest.PAPER_OR_PLASTIC:
			
			name = "Paper or Plastic?"
			icon_key = "paper"
			color_key = "lead"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Axes", "axe", {"other_key": "axe", "amount": "3000"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Wood Pulp", "pulp", {"other_key": "pulp"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Paper", "paper", {"other_key": "paper"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Petroleum", "pet", {"other_key": "pet"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Plastic", "plast", {"other_key": "plast"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "lead", {"amount": "800", "req_key": "lead"}))
		
		gv.Quest.CARCINOGENIC:
			
			name = "Carcinogenic"
			desc = "Hey, smoke up, Johnny!"
			icon_key = "carc"
			
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Tobacco", "toba", {"other_key": "toba"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Cigarette", "ciga", {"other_key": "ciga"}))
			reward.append(Reward.new(gv.QuestReward.NEW_LORED, "New LORED: Carcinogen", "carc", {"other_key": "carc"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "paper", {"amount": "100", "req_key": "paper"}))
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "plast", {"amount": "100", "req_key": "plast"}))
		
		gv.Quest.CRINGEY_PROGRESS:
			
			name = "Cringey Progress"
			icon_key = "s2"
			
			reward.append(Reward.new(gv.QuestReward.RESOURCE, "Steel", "steel", {"other_key": "steel", "amount": "1000"}))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADE_PURCHASED, gv.up["Sagan"].icon, {"req_key": "Sagan"}))
		
		gv.Quest.CANCER_LORD:
			
			name = "Cancer Lord"
			desc = "Did you think you'd ever get here?"
			icon_key = "s2m"
			
			reward.append(Reward.new(gv.QuestReward.UPGRADE_MENU, "Radiative Upgrade Menu", "s2m", {"other_key": "s2m"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "tum", {"amount": "5000", "req_key": "tum"}))
		
		gv.Quest.HORSE_DOODIE:
			
			name = "Horse Doodie"
			icon_key = "copy"
			color_key = "spike"
			
			reward.append(Reward.new(gv.QuestReward.OTHER, "10x easier tasks!", "copy"))
			
			req.append(Requirement.new(gv.TaskRequirement.UPGRADES_PURCHASED, "s2m", {"amount": "30", "req_key": "s2m"}))
		
		gv.Quest.A_DARK_DISCOVERY:
			name = "A Dark Discovery"
			icon_key = "embryo"
			
			reward.append(Reward.new(gv.QuestReward.UPGRADE_MENU, "The Runed Dial", "s3n", {"other_key": "s3n"}))
			
			req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "tum", {"amount": "1e40", "req_key": "tum"}))
	
	icon = gv.sprite[icon_key]
	
	if color_key == "":
		color_key = icon_key
	color = gv.COLORS[color_key]
	
	if repeatable:
		times_completed = 0
	
	set_total_points()
	
	for r in req:
		if r.done:
			reqs_done += 1

func update():
	
	reward.clear()
	
	if gv.g[name.to_lower()].active:
		reward.append(Reward.new(gv.QuestReward.UPGRADE_LORED, "LORED level up", name.to_lower()))
	else:
		reward.append(Reward.new(gv.QuestReward.UPGRADE_LORED, "Unlock LORED", name.to_lower()))
	
	req.clear()
	
	match key:
		gv.Quest.HUNT:
			match times_completed:
				0:
					req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "bone", {"amount": "200", "req_key": "bone"}))
					req.append(Requirement.new(gv.TaskRequirement.SPELL_CAST, "witch", {"amount": "3", "req_key": str(gv.SpellID.HEX) + " cast"}))
		gv.Quest.WITCH:
			match times_completed:
				0:
					req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "iron", {"amount": "10", "req_key": "iron"}))
					req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "meat", {"amount": "10", "req_key": "meat"}))
					req.append(Requirement.new(gv.TaskRequirement.RESOURCE_PRODUCTION, "fur", {"amount": "20", "req_key": "fur"}))
	
	set_total_points()

func reset():
	
	complete = false
	times_completed = 0
	
	for r in req:
		r.reset()
	
#	for s in step:
#		step[s].f = Big.new(0)

func turn_in(manual: bool, _load = false):
	
	if not _load and complete:
		print_debug("Tried to turn in ", name, "--task is already complete.")
		return
	
	if not _load:
		times_completed += 1
	if not repeatable:
		complete = true
	
	
	for r in reward:
		match r.type:
			gv.QuestReward.STAGE:
				gv.emit_signal("quest_reward", r.type, r.other_key)
			gv.QuestReward.MAX_TASKS:
				taq.max_tasks += 1
			gv.QuestReward.OTHER:
				gv.emit_signal("quest_reward", r.type, str(key))
			gv.QuestReward.NEW_LORED:
				gv.g[r.other_key].unlock()
			gv.QuestReward.UPGRADE_MENU:
				gv.emit_signal("quest_reward", r.type, r.other_key)
			gv.QuestReward.RESOURCE:
				if not _load:
					gv.r[r.other_key].a(r.amount)
					taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, r.other_key, r.amount)
	
	if random:
		gv.stats.tasks_completed += 1
	
	if not _load:
		manager.rt.off_check()
	
	if key in [gv.Quest.RANDOM_RARE, gv.Quest.RANDOM_SPIKE]:
		taq.progress(gv.TaskRequirement.RARE_OR_SPIKE_TASKS_COMPLETED)
	elif not _load:
		taq.progress(gv.TaskRequirement.TASKS_COMPLETED)
	
	if _load and not random:
		return
	
	die(manual, _load)

func die(manual: bool, _load = false):
	
	if random:
		taq.cur_tasks -= 1
	
	if not is_instance_valid(manager):
		return
	
	manager.hide()
	
	if manual:
		manager.rt.get_node("global_tip")._call("no")
	
	if random:
		
		if manual:
			manager.rt.get_node("global_tip")._call("no")
		
		manager.hide()
		taq.task_manager.content.erase(self) # erases this task from content too
		
		if not _load:
			var gayzo = {}
			for r in reward:
				if not r.type == gv.QuestReward.RESOURCE:
					continue
				
				gayzo[r.other_key] = Big.new(r.amount)
			
			if complete:
				taq.task_manager.finished_task(gayzo)
		
		manager.queue_free()
		
		taq.task.erase(self)
	
	else:
		
		manager.get_parent().quest_ended()
	
	manager.queue_free()






#func w_task_effects(which := []) -> void:
#
#	for x in which:
#
#		for v in quests[x].reward:
#			if "New LORED: " in v:
#				var key = v.split("New LORED: ")[1]
#				gv.g[key].unlocked = true
#				get_node(gnLOREDs).cont[key].show()
#			if "Upgrade the %s LORED!" == v:
#				var key = x.to_lower()
#				gv.g[key].manager.buy(false)
#
#		match x:
#			"Spike":
#			"Upgrades!":
#			"A New Leaf":
#				unlock_tab("1")
#				unlock_tab("2")
#				get_node("misc/menu").w_display_run(quests[x].complete)
#			"Welcome to LORED":
#				unlock_tab("s1n")
#			"Consume":
#				unlock_tab("s1m")
#			"The Heart of Things":
#				gv.g["tum"].unlocked = true
#				if get_node(gnLOREDs).cont["seed"].b_ubu_s2n_check():
#					unlock_tab("s2n")
