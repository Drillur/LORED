extends MarginContainer

onready var rt = get_node("/root/Root")

const prefabs := {
	block = preload("res://Prefabs/task/random_task_block.tscn"),
	task_complete = preload("res://Prefabs/lored_buy.tscn"),
	d_text = preload("res://Prefabs/dtext.tscn"),
}

var content := {}
var effects_content := {}

var ready_task_count = 0
var time_since_last_shake = 0.0
var last_y := 0.0

func _physics_process(delta):
	
	shake()

func shake() -> void:
	
	# shake if done
	
	if ready_task_count == 0:
		return
	
	time_since_last_shake += get_physics_process_delta_time()
	if time_since_last_shake < 5:
		return
	
	time_since_last_shake -= 5
	
	w_shake_self()

func init(_tasks := []):
	
	if not gv.menu.option["task auto"]:
		$HBoxContainer/auto/Label.show()
		$HBoxContainer/auto/AnimatedSprite.hide()
	
	for x in _tasks:
		add_task(x)

func hit_max_tasks():
	while taq.cur_tasks < taq.max_tasks:
		add_task(_generate_random_task())


func flying_numbers(f := {}):
	
	ready_task_count -= 1
	time_since_last_shake = 0.0
	
	if not gv.menu.option["flying_numbers"]:
		return
	
	var left_x = rect_global_position.x + rect_size.x / 2
	var ypos = rect_global_position.y - 5
	
	var i = 0
	for x in f:
		
		rt.save_fps -= 0.09
		var t = Timer.new()
		t.set_wait_time(0.09)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		left_x += rand_range(-10,10)
		
		if x == "growth":
			rt.get_node(rt.gnLOREDs).cont[x].w_bonus_output(x, f[x])
		
		var key = "flying freaking numbers " + str(i)
		
		effects_content[key] = prefabs.d_text.instance()
		effects_content[key].init(false,-50, "+ " + f[x].toString(), gv.sprite[x], gv.g[x].color)
		rt.get_node("texts").add_child(effects_content[key])
		
		if i == 0:
			effects_content[key].rect_position = Vector2(left_x, ypos)
		else:
			for v in i:
				effects_content["flying freaking numbers " + str(v)].rect_position.y -= 7
			effects_content[key].rect_position = Vector2(
				left_x - effects_content[key].rect_size.x / 2,
				effects_content["flying freaking numbers " + str(i-1)].rect_position.y + effects_content[key].rect_size.y
			)
		
		i += 1


func add_task(task) -> void:
	
	#task.code = stepify(task.code, 0.01)
	
	content[task.code] = prefabs.block.instance()
	$HBoxContainer.add_child(content[task.code])
	$HBoxContainer.move_child(content[task.code], 0)
	taq.task[task.code] = task#taq.Task.new(task.name, task.desc, task.resource_reward, task.reward, task.step, task.icon, task.color)
	content[task.code].init(task.icon, task.code, task.color)
	
	taq.cur_tasks += 1

func _generate_random_task() -> taq.Task:
	
	var roll : int = 0#rand_range(0, 2)
	var type : String
	var key: String
	
	match roll:
		0:
			type = "collect"
	
	# difficulty of step
	var rall : float = rand_range(20,200) # 20-199
	var rarity_roll :float=rand_range(0,100) if gv.stats.tasks_completed > 15 else 10.0
	
	if rarity_roll < 5: rall *= 10 # rare task
	if rarity_roll < 0.1: rall *= 100 # spike task
	
	if rt.quests["Horse Doodie"].complete:
		rall /= 10
	rall /= gv.hax_pow
	
	if gv.stats.tasks_completed < 3:
		rall /= 2
	if gv.stats.tasks_completed < 5:
		rall /= 2
	if gv.stats.tasks_completed < 30:
		rall /= 2
	if gv.stats.tasks_completed < 45:
		rall /= 1.5
	
	# which LORED is the step messing with
	while true:
		
		key = gv.g.keys()[randi() % gv.g.size()]
		
		if not gv.g[key].unlocked:
			continue
		if not gv.g[key].active:
			continue
		if key == "growth" and not gv.g["jo"].active:
			continue
		
		var cont := false
		for x in gv.g[key].b:
			if not gv.g[x].active:
				cont = true
				break
		
		if cont:
			continue
		
		for x in gv.g[key].b:
			
			if "no" in gv.menu.f:
				if int(gv.g[x].type[1]) <= int(gv.menu.f.split("no s")[1]):
					cont = true
					break
			
			if not gv.g[x].active:
				cont = true
				break
		
		if cont:
			continue
		
		if "2" == gv.g[key].type[1] and gv.stats.run[1] == 1:
			rall *= 0.1
		break
	
	var name : String
	var desc : String
	var rr := {}
	var r := {}
	var step := {}
	var icon := {texture = gv.sprite["unknown"], key = "unknown"}
	
	var rr_size := 1
	if rarity_roll >= 0.1:
		roll = rand_range(0, 100)
		if roll > 95: rr_size = 4
		elif roll > 85: rr_size = 3
		elif roll > 50: rr_size = 2
		else: rr_size = 1
	
	var time := Big.new(0)
	
	# name / desc / step / icon
	if true:
		
		# icon
		icon.key = key
		icon.texture = gv.sprite[key]
		
		# name
		while true:
			
			name = generate_task_name(key)
			
			if rarity_roll <= 0.1:
				name = name + " {Spike}"
			elif rarity_roll <= 5:
				name = name + " (Rare)"
			
			if not name in content.keys():
				break
		
		# desc / step
		match type:
			"collect":
				
				var net = Big.new(gv.g[key].net(true)[0])
				
				var amount: Big = Big.new(rall).m(Big.new(Big.max(gv.g[key].d.b, net))).m(rr_size)
				
				step[gv.g[key].name + " produced"] = Ob.Num.new(amount)
				time.a(amount).d(60)
				time.d(Big.new(Big.max(net, 0.05)))
				desc = "Collect " + gv.g[key].name + "."
	
	# resource_reward
	if true:
		
		for x in rr_size:
			
			# spike task only
			if "{Spike}" in name:
				var gg = "malig"
				match gv.stats.highest_run:
					2:
						gg = "tum"
				var reward = Big.new(Big.max(gv.stats.most_resources_gained, gv.stats.run[gv.stats.highest_run - 1] * 1000))
				var cawk = Big.new(gv.g[gg].net(true)[0]).m(1000)
				if reward.isLessThan(cawk):
					reward.a(cawk)
				reward.m(rand_range(0.9, 1.1))
				rr[gg] = reward
			
			else:
				
				var b = 0
				var blacklist = "plast jo coal irono copo oil tar growth draw humus sand gale pulp paper soil toba tree "
				
				while true:
					
					roll = int(rand_range(0, gv.g.size()))
					b = rt.w_index_to_short(roll)
					
					if rarity_roll < 5:
						if b + " " in blacklist: continue
					if b == "growth" and not gv.g["jo"].active: continue
					if b in "malig tum":
						if gv.stats.run[int(gv.g[b].type[1])] == 1:
							continue
					
					if not gv.g[b].unlocked:
						continue
					
					var cont := false
					for v in gv.g[b].b:
						if "no" in gv.menu.f:
							var menu = gv.menu.f.split("no ")[1]
							if menu in gv.g[v].type:
								cont = true
								break
						if gv.g[v].active: continue
						if gv.stats.run[int(gv.g[v].type[1]) - 1] == 1: continue
						cont = true
						break
					
					if cont: continue
					
					break
				
				var progression_mod :float= gv.stats.tasks_completed / 10
				if progression_mod < 1: progression_mod = 1.0
				if progression_mod > 100: progression_mod = 100.0
				var quest_mod = 10.0 if rt.quests["Horse Doodie"].complete else 1.0
				
				var dink: Big = Big.new(gv.g[b].net(true)[0]).m(progression_mod).m(time).m(quest_mod)
				if "(Rare)" in name: dink.m(rand_range(1.0, 3.0))
				
				#dink *= 1 + time
				
				if gv.stats.tasks_completed < 10:
					dink.m(4)
				if gv.stats.tasks_completed < 20:
					dink.m(2)
				if gv.stats.tasks_completed < 30:
					dink.m(1.5)
				if gv.stats.tasks_completed < 40:
					dink.m(1.25)
				
				var reward: Big = Big.new(dink).m(rand_range(0.9,1.1))
				
				if reward.isLessThan(1):
					reward.mantissa = 1.0
				elif reward.exponent < 2:
					reward.mantissa = round(reward.mantissa)
				
				var _key = rt.w_index_to_short(roll)
				
				if _key in rr.keys():
					rr[_key].a(reward)
				else:
					rr[_key] = reward
	
	var _task = taq.Task.new(name, desc, rr, r, step, icon, gv.g[key].color)
	
	_task.code = stepify(rand_range(0,100.0), .01)
	while _task.code in content.keys():
		_task.code = stepify(rand_range(0,100.0), .01)
	
	return _task

func generate_task_name(lored : String, roll := 0) -> String:
	
	roll = rand_range(0, 3)
	
	match lored:
		"glass":
			match roll:
				0:
					return "Fall of Reach"
				1:
					return "shame about that there planet(s)"
				2:
					return "First Strike"
		"wood":
			match roll:
				0:
					return "Quit acting demicky, Virginia."
				1:
					return "DEFEATING A SANDWICH ONLY MAKES IT TASTIER"
				2:
					return "yo the naavi aint gon lik dis"
		"gale":
			match roll:
				0:
					return "Greasy Jack"
				1:
					return "Bouncy Boy"
				2:
					return "ayayayayayayayayayayaya"
		"ciga":
			match roll:
				0:
					return "Marlboro Massacre"
				1:
					return "Pall Mall Suicide"
				2:
					return "Nicotine Death"
		"toba":
			match roll:
				0:
					return "white shores"
				1:
					return "the Green Dragon"
				2:
					return "Mead and Hearth"
		"liq":
			match roll:
				0:
					return "SUPER> HOT. SUPER> HOT. SUPER> HOT."
				1:
					return "Liquid Conquest"
				2:
					return "bonk"
		"sand":
			match roll:
				0:
					return "It's Coarse, and Rough, and Irritating, and it Gets Everywhere"
				1:
					return "SANDY CHEEKS DUH"
				2:
					return "The LORED Wars"
		"humus":
			roll = rand_range(0, 4)
			match roll:
				0:
					return "nobody even knows what this is"
				1:
					return "what is this, horse shit?"
				2:
					return "OK Google. Define \"horse shit\"."
				3:
					return "A Horse With No Name"
		"soil":
			roll = rand_range(0, 4)
			match roll:
				0:
					return "d"
				1:
					return "i"
				2:
					return "r"
				3:
					return "t"
		"tree":
			match roll:
				0:
					return "acrobatic stuff"
				1:
					return "What is this, Minecraft?"
				2:
					return "MAGNETIC ACCELERATOR TREE SEEDS"
		"seed":
			match roll:
				0:
					return "What is this, Stardew Valley?"
				1:
					return "nobody even gardens in real life"
				2:
					return "the bee life is the life for me"
		"water":
			match roll:
				0:
					return "Splish Splash Take a Bath"
				1:
					return "Rainydaywriter"
				2:
					return "Dribbly Doobly"
		"coal":
			match roll:
				0:
					return "Coallector"
				1:
					return "Thirsty Boi!"
				2:
					return "Smudgey"
		"stone":
			match roll:
				0:
					return "Stoneheart"
				1:
					return "Stoneard"
				2:
					return "Stonebridge"
		"irono":
			match roll:
				0:
					return "Schploopty"
				1:
					return "Light Em Up!"
				2:
					return "Fire!"
		"copo":
			match roll:
				0:
					return "Mine!!"
				1:
					return "Picker!"
				2:
					return "Put Your Back Into It!"
		"iron":
			match roll:
				0:
					return "Irony"
				1:
					return "I AM the LORED."
				2:
					return "Smelt it."
		"cop":
			match roll:
				0:
					return "Copaloppy"
				1:
					return "Get to the Copper"
				2:
					return "Orange!"
		"growth":
			match roll:
				0:
					return "ew"
				1:
					return "It's not a growth!"
				2:
					return "Tummy"
		"conc":
			match roll:
				0:
					return "Conky"
				1:
					return "Cement"
				2:
					return "Snap"
		"jo":
			match roll:
				0:
					return "TESLA!!"
				1:
					return "ELECTRICITY"
				2:
					return "PHYSICS"
		"malig":
			match roll:
				0:
					return "That's cancer, dude."
				1:
					return "Stage Eleven"
				2:
					return "GoopyDoopy"
		"tar":
			match roll:
				0:
					return "Make That Tar Slap"
				1:
					return "Jiggle that Jangle"
				2:
					return "Wobble Bobble"
		"oil":
			match roll:
				0:
					return "Slurp!"
				1:
					return "Delicious!"
				2:
					return "Suck faster!"
		"steel":
			match roll:
				0: return "Pounder"
				1: return "Corona Blacksmith"
				2: return "For the Steelless"
		"axe":
			match roll:
				0: return "Quantity Over Quality"
				1: return "Automataxed"
				2: return "Factory Axes"
		"hard":
			match roll:
				0: return "OnlyHardwoodFans"
				1: return "Hardhat Zone"
				2: return "Free $10k Life Insurance!"
		"wire":
			match roll:
				0: return "Knickers"
				1: return "Cookies"
				2: return "Have Some Lunch!"
		"draw":
			match roll:
				0: return "Doodley"
				1: return "Paper or Electronic?"
				2: return "Ctrl-Z in Bulk"
		"pulp":
			match roll:
				0: return "Jus' securin' my jerb, hyere."
				1: return "You 'kin fuck my girlfriend and shoot my mother, but don'tchu dare say a bad word about my truck."
				2: return "http://FarmerMingle.com"
		"carc":
			match roll:
				0: return "Pretty sure that thing's evil"
				1: return "Devil's Dance"
				2: return "Pleasure Over Wisdom"
		"lead":
			match roll:
				0: return "What is that, a magnet?"
				1: return "Why's that guy so mad?"
				2: return "He's just standing there... menacingly!"
		"pet":
			match roll:
				0: return "BASTARD FROM A BASKET!"
				1: return "I have a competition in me... I want no one else to succeed."
				2: return "I hate most people."
		"paper":
			match roll:
				0: return "Pen and Paper"
				1: return "Papers, Please"
				2: return "Paper Man"
	
	match roll:
		0:
			return "placeholder0"
		1:
			return "placeholder1"
	
	return "placeholder2"


func erase(_erase := -1.0) -> void:
	
	if _erase != -1.0:
		taq.cur_tasks -= 1
		content.erase(_erase)
		add_task(_generate_random_task())


func w_shake_self() -> void:
	
	# shake
	var time_between_shakes = 0.1
	
	rect_rotation = 1
	w_move_around(-rect_rotation * 1.5)
	
	var t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = -1
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = 0.8
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = -.7
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = .5
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = -0.2
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = .05
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = 0
	w_move_around(-rect_rotation * 1.5)
	last_y = 0.0
func w_move_around(y) -> void:
	rect_position.y -= last_y
	rect_position.y += y
	last_y = y


func _on_auto_button_down() -> void:
	rt.get_node("map").status = "no"


func _on_auto_pressed() -> void:
	
	if not gv.menu.option["task auto"]:
		gv.menu.option["task auto"] = true
		$HBoxContainer/auto/Label.hide()
		$HBoxContainer/auto/AnimatedSprite.show()
		for x in content:
			if content[x].get_node("tp").value >= 100:
				content[x]._on_task_pressed()
		return
	
	gv.menu.option["task auto"] = false
	$HBoxContainer/auto/Label.show()
	$HBoxContainer/auto/AnimatedSprite.hide()
