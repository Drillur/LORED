class_name Wish
extends Reference



var key: String

var name := ""
var giver: String

var help_text: String
var thank_text: String
var help_expression := "angry"
var thank_expression := "test"

var rewards := 0

var random: bool
var ready := false
var exists := true
#var major_wish: bool
var complete := false

var color: Color
var color_key: String

var obj: Objective # objective
var rew: Array # rewards
var key_rew: Array

var vico: MarginContainer
var tooltip: MarginContainer
var tooltip_active := false






class Objective:
	
	var type: int
	var key: String
	
	var current_count: Big = Big.new(0)
	var required_count: Big
	
	var complete := false
	
	var icon_key: String
	
	
	func _init(_type: int, _key: String, _count := "0"):
		
		if _type == -1:
			_load(str2var(_key))
			return
		
		type = _type
		key = _key
		
		if _count == "0":
			assumeCount()
		else:
			required_count = Big.new(_count)
		
		assumeIconKey()
		
		if alreadyComplete():
			complete()
	
	
	func save() -> Dictionary:
		
		var data := {}
		
		data["type"] = var2str(type)
		data["key"] = var2str(key)
		
		data["current_count"] = var2str(current_count)
		data["required_count"] = var2str(required_count)
		
		data["complete"] = var2str(complete)
		
		return data
	
	func _load(data: Dictionary):
		
		type = str2var(data["type"])
		key = str2var(data["key"])
		
		current_count = str2var(data["current_count"])
		required_count = str2var(data["required_count"])
		
		complete = str2var(data["complete"])
		
		if icon_key == "":
			assumeIconKey()
	
	
	func alreadyComplete() -> bool:
		
		match type:
			gv.Objective.UPGRADE_PURCHASED:
				return gv.up[key].have
		
		return false
	
	func assumeIconKey():
		if key in gv.sprite:
			setIconKey(key)
			return
		if type == gv.Objective.UPGRADE_PURCHASED:
			setIconKey(gv.up[key].icon)
	
	func setIconKey(_icon_key: String):
		icon_key = _icon_key
	
	func assumeCount():
		match type:
			gv.Objective.MAXED_FUEL_STORAGE:
				required_count = Big.new(99)
			_:
				required_count = Big.new(1)
	
	func parseCount() -> String:
		if complete:
			if required_count.equal(1):
				return "1/1"
			return "Complete!"
		if type == gv.Objective.MAXED_FUEL_STORAGE:
			return fval.f(current_count.percent(100) * 100) + "%"
		
		return current_count.toString() + "/" + required_count.toString()
	
	func parseObjective() -> String:
		
		match type:
			gv.Objective.RESOURCES_PRODUCED:
				if gv.isStage1Or2LORED(key):
					return "Collect " + gv.g[key].name
				else:
					return "Collect " + gv.r_name[key]
			gv.Objective.LORED_UPGRADED:
				return "Upgrade " + gv.g[key].name
			gv.Objective.UPGRADE_PURCHASED:
				return "Purchase " + gv.up[key].name
			gv.Objective.MAXED_FUEL_STORAGE:
				return gv.g[key].name + " max fuel"
			gv.Objective.BREAK:
				return "Relax"
			gv.Objective.HOARD:
				return "Hoard!"
			gv.Objective.RESET:
				return "Reset!"
		
		print_debug("Wish parseObjective fail. Type: ", type)
		return "Oops!"

	func complete():
		complete = true

	func match(_type: int, _key: String) -> bool:
		return _key == key and _type == type

	func increaseCount(amount: Big):
		if complete:
			return
		current_count.a(amount)
		checkIfComplete()
	
	func setCount(amount: Big):
		if complete:
			return
		current_count = Big.new(amount)
		checkIfComplete()
	
	func checkIfComplete():
		if current_count.greater_equal(required_count):
			complete()
		if current_count.greater(required_count):
			current_count = Big.new(required_count)

class Reward:
	
	var type: int
	
	var key: String
	
	var amount: Big
	
#	var icon_key: String
	
	
	func _init(_type: int, _key: String, _amount = 1):
		
		if _type == -1:
			_load(str2var(_key))
			return
		
		type = _type
		key = _key
		amount = Big.new(_amount)
	
	
	func save() -> Dictionary:
		
		var data := {}
		
		data["type"] = var2str(type)
		data["key"] = var2str(key)
		
		data["amount"] = var2str(amount)
		
		return data
	
	func _load(data: Dictionary):
		
		type = str2var(data["type"])
		key = str2var(data["key"])
		
		amount = str2var(data["amount"])
	
	func turnIn():
		match type:
			gv.WishReward.RESOURCE:
				gv.r[key].a(amount)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, key, amount)
			gv.WishReward.NEW_LORED:
				gv.g[key].unlock()
			gv.WishReward.TAB:
				gv.emit_signal("wishReward", type, key)
			gv.WishReward.MAX_RANDOM_WISHES:
				taq.max_random_wishes += amount.toFloat()











func _init(_key: String, data: Dictionary = {}):
	
	if _key == "load":
		
		_load(data)
	
	else:
		
		key = _key
		
		random = key == "random"
		
		var construct_method = "construct_" + key
		call(construct_method)
		
		assumeName()
		assumeColor()
		
		#major_wish = key != "random"
		rewards = rew.size()
	
	if obj.icon_key == "":
		obj.setIconKey(giver)

func assumeName():
	if name != "":
		return
	name = key.capitalize()

func assumeColor():
	if obj.type == gv.Objective.MAXED_FUEL_STORAGE:
		setColor(gv.g[obj.key].fuel_source)
		return
	if obj.key in gv.COLORS.keys():
		setColor(obj.key)
		return
	setColor("common")

func setColor(_color_key: String):
	color_key = _color_key
	color = gv.COLORS[color_key]

func setTooltip(_tooltip: MarginContainer):
	tooltip = _tooltip
	tooltip_active = true

func clearTooltip():
	tooltip_active = false

func setVico(_vico: MarginContainer):
	vico = _vico
	vico.wish = self



func save() -> Dictionary:
	
	var data := {}
	
	data["key"] = key
	data["name"] = name
	data["giver"] = giver
	data["help_text"] = help_text
	data["thank_text"] = thank_text
	data["color_key"] = color_key
	data["random"] = var2str(random)
	data["ready"] = var2str(ready)
	
	data["obj"] = var2str(obj.save())
	
	data["rewards"] = var2str(rewards)
	for r in rewards:
		var _key = "reward" + str(r)
		data[_key] = var2str(rew[r].save())
	
	return data

func _load(data: Dictionary):
	key = data["key"]
	name = data["name"]
	giver = data["giver"]
	help_text = data["help_text"]
	thank_text = data["thank_text"]
	setColor(data["color_key"])
	random = str2var(data["random"])
	ready = str2var(data["ready"])
	
	obj = Objective.new(-1, data["obj"])
	
	rewards = str2var(data["rewards"])
	for r in rewards:
		var _key = "reward" + str(r)
		rew.append(Reward.new(-1, data[_key]))

func die(inform_taq := true):
	vico.hide()
	exists = false
	if tooltip_active:
		vico._on_Button_mouse_exited()
	if random:
		taq.random_wishes -= 1
	if inform_taq:
		# false when called from wishManager.gd
		taq.wishDied(self)


func increaseCount(_type: int, _key: String, amount):
	
	if not exists:
		return
	
	if obj.match(_type, _key):
		amount = Big.new(amount)
		obj.increaseCount(amount)
		checkIfReady()

func setCount(_count: Big):
	obj.setCount(_count)
	checkIfReady()

func checkIfReady():
	if obj.complete:
		ready()
	else:
		vico.update()
	

func ready():
	ready = true
	vico.ready()
	if tooltip_active:
		if not is_instance_valid(tooltip):
			clearTooltip()
			return
		tooltip.updateDialogueAndExpression()
		tooltip.updateRandomVisibility()

func turnIn():
	
	complete = true
	
	for r in rew:
		r.turnIn()
	
	taq.wishCompleted(self)
	
	gv.r["joy"].a(1)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "joy")
	
	die()




























func construct_upgrade_name():
	giver = "malig"
	help_text = "Hey, listen, I got a joke for ya. Come here, it's funny. You'll laugh. No, I promise. Alright. What do you get when you don't stop spending all my hard-earned Malignancy on bullshit-ass Upgrades?\n\nTwo broken legs!\n\nWhat, don't you get it? Hey, don't worry. It's a slow-burn type of punchline. You'll get it later."
	thank_text = "[i]Upgrade_name[/i], huh? There's a solid Upgrade. I'm proud of you. Hey, what--are you still trying to figure out that joke? Forget about it."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "upgrade_name")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "iron", "1e6"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, "cop", "1e6"))

func construct_joy2():
	giver = "iron"
	help_text = "This one just came in straight from the developer himself! No, really! Don't believe me? Ask him!"
	thank_text = "Hey, the developer sent a message for you, as if I were some kind of Post LORED: \"You're a big stinky winky.\"\n\nI swear! It was him!! Not me! I can't believe he made me say that."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, "joy", "10")
	rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))
	key_rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))

func construct_soccer_dude():
	giver = "copo"
	help_text = "You've got to reset to get this one, boss, see? But, you don't have to reset right now, boss. Do what you want, you're the boss, boss, see, boss?"
	thank_text = "Wicked, boss, real wicked. We're rolling with the big cats, now, boss."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "SOCCER DUDE")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "malig", "1000"))

func construct_malignancy():
	giver = "malig"
	help_text = "Yo, goo-goo ga-ga, I'm a fucken baby, what's good? I just materialized from the malignancy in the surrounding environment, you got a problem with it? Yeah, shut up.\n\nSo anyways, like I was sayin, sometimes--sometimes, in order to go forward, you gotta go back, know what I'm sayin? So, like, you've got these crazy-style Upgrades over here that--ahem--[i]only I[/i] can afford, all right? So, it's all thanks to me is what I'm sayin.\n\nYou don't know what I'm talkin about? Man, get the fuck outta here."
	thank_text = "Yeah, whatever. Just go do some resettin, see if I care."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, "malig", "3e3")
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.MALIGNANT)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.MALIGNANT)))

func construct_sand():
	giver = "jo"
	help_text = "If you really want to progress, you could get this Upgrade over here."
	thank_text = "Yeah, uhh... good job."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "SAND")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "malig", "10"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "tar"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "oil"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "malig"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "tar"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "oil"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "malig"))

func construct_rye():
	giver = "growth"
	help_text = "[i]I CURRENTLY AM IN AN UNFORTUNATE SITUATION."
	thank_text = "[i]IT WOULD APPEAR THAT THERE WILL BE NO END TO MY SUFFERING."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "RYE")
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "jo"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "conc"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "jo"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "conc"))

func construct_joy():
	giver = "iron"
	help_text = "Hey, it looks like everyone is opening up to you! They're sharing their Wishes! Isn't that nice?"
	thank_text = "Whoa, look! Growth just showed up!"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, "joy", "3")
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "growth"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "growth"))

func construct_grinder():
	giver = "stone"
	help_text = "Whoa?! Does the GRINDER upgrade work on rocks?"
	thank_text = "GRINDER is awesome!"
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "GRINDER")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "iron", 30))
	rew.append(Reward.new(gv.WishReward.RESOURCE, "cop", 30))
	rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))
	key_rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))

func construct_upgrades():
	giver = "copo"
	help_text = "Ey, boss, I see you workin hard, real hard, I like that. But, lemme tell ya--you could be gettin this done a lot easier if you just did it with actual Upgrades. No, not upgrades like y'been doin--[i]Upgrades[/i], boss, [i]Upgrades[/i]! Whataya say to passin me a couple Stone--say, 40--and I tell ya all about Upgrades?"
	thank_text = "That's sweet, boss, that's real sweet. Thanks for the dough, I'm gonna put this to real good use, you'll see. Catch ya later, boss, catch ya later. Oh! Upgrades, right. Just press Q, boss, you can handle it."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, "stone", "40")
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.NORMAL)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.NORMAL)))

func construct_upgrade_stone():
	giver = "iron"
	help_text = "Stone seems like he's got a little much to do. Could you upgrade him to make it easier on him?"
	thank_text = "Awesome! I bet he's liking that. Thanks :)" #note replace any :) text found in help_text or thank_text with the Joy icon. DO IT
	obj = Objective.new(gv.Objective.LORED_UPGRADED, "stone")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "stone", 50))

func construct_importance_of_coal():
	giver = "coal"
	help_text = "Yikes!! Everyone is taking my stuff! No rest for the righteous, I guess!"
	thank_text = "Whew."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, "coal", "25")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "coal", 50))

func construct_collection():
	giver = "stone"
	help_text = "I'm just going to pick up some of these."
	thank_text = "Rocks are neat."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, "stone", "10")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "iron", 20))
	rew.append(Reward.new(gv.WishReward.RESOURCE, "cop", 10))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "irono"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "copo"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "iron"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, "cop"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "irono"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "copo"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "iron"))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, "cop"))

func construct_fuel():
	giver = "coal"
	help_text = "If Stone wants my stuff, I'm happy to share!"
	thank_text = "Glad I could help. :)"
	obj = Objective.new(gv.Objective.MAXED_FUEL_STORAGE, "stone")
	rew.append(Reward.new(gv.WishReward.RESOURCE, "coal", 10))
	rew.append(Reward.new(gv.WishReward.RESOURCE, "stone", 10))

func construct_stuff():
	giver = "stone"
	help_text = "I want to pick up rocks, but I'm out of [i]stuff[/i]. Help!"
	thank_text = "That's the stuff. Thanks!"
	obj = Objective.new(gv.Objective.LORED_UPGRADED, "coal")

























func construct_random():
	
	var selected_type: String
	
	if gv.r["joy"].greater(8):
		
		var possible_types: Dictionary = get_possible_types()
		
		var total_points: int
		for p in possible_types:
			total_points += possible_types[p]
		
		var roll = randi() % total_points
		var shuffled_possible_types: Array = possible_types.keys()
		shuffled_possible_types.shuffle()
		
		#print("total points: ", total_points)
		for i in shuffled_possible_types.size():
			#print("roll ", i, ": ", roll, "; rolling against ", possible_types[shuffled_possible_types[i]])
			if roll < possible_types[shuffled_possible_types[i]]:
				selected_type = shuffled_possible_types[i]
				break
			roll -= possible_types[shuffled_possible_types[i]]
	
	else:
		selected_type = "random_collect"
	
	key = selected_type
	
	var construct_method = "construct_" + key if not ":" in key else "construct_" + key.split(":")[0]
	call(construct_method)
	
	generateHelpAndThankText()

func get_possible_types() -> Dictionary:
	
	var possible_types := {
		"random_upgrade_lored": 10,
		"random_collect": 50,
		"random_break_or_hoard": 10,
	}
	
	# buy_upgrade 25
	if notAnotherOngoingWishOfThisType("random_buy_upgrade"):
		for i in gv.Tab.values():
			
			if i == gv.Tab.S1:
				break
			
			var exit := false
			
			for x in gv.list.upgrade["unowned " + str(i)]:
				var time_to_buy = gv.up[x].time_to_buy()
				if not time_to_buy is Big:
					continue
				if time_to_buy.less(120) and gv.up[x].manager.availableToBuy():
					possible_types["random_buy_upgrade:" + x] = 15
					exit = true
					break
			
			if exit:
				break
	
	# reset 5
	if notAnotherOngoingWishOfThisType("random_reset"):
		
		var reset_key: String = gv.highestResetKey()
		
		if gv.r[reset_key].greater(Big.new(gv.stats.most_resources_gained).m(0.25)):
			possible_types["random_reset"] = 5
	
	# max_fuel 100
	if notAnotherOngoingWishOfThisType("random_max_fuel"):
		for x in gv.list.lored["active"]:
			var percent_of_max = Big.new(gv.g[x].f.t).m(0.25)
			if gv.g[x].f.f.less(percent_of_max):
				possible_types["random_max_fuel:" + x] = 100
				break
	
	# joy_or_grief 20
	if true:
		if notAnotherOngoingWishOfThisType("random_joy_or_grief"):
			possible_types["random_joy_or_grief"] = 20
	
	return possible_types

func notAnotherOngoingWishOfThisType(_key: String) -> bool:
	# wishes that call this function are limited to 1
	for w in taq.wish:
		if w.key == _key:
			return false
	return true

#   -   -   -   -   -   -   -   -   -   -

func construct_random_upgrade_lored():
	
	setRandomGiver()
	
	obj = Objective.new(gv.Objective.LORED_UPGRADED, randomLORED())
	
	generateRandomRewards(30)

func construct_random_collect():
	
	setRandomGiver()
	
	var resource = randomResource()
	
	var difficulty = rand_range(20,80)
	
	var s1_or_s2 = gv.isStage1Or2LORED(resource)
	
	# stage 1 or 2
	if s1_or_s2:
		difficulty /= gv.g[resource].speed.t
	
	var amount: Big = Big.new(difficulty).m(gv.g[resource].d.t)
	
	# stage 1 or 2
	if s1_or_s2:
		if gv.g[resource].stage == "2" and gv.stats.run[1] == 1:
			amount.d(10)
	
	amount.mantissa = floor(amount.mantissa)
	
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, resource, amount.toScientific())
	
	generateRandomRewards(difficulty / 2)

func construct_random_break_or_hoard():
	
	setRandomGiver()
	
	var roll: int = randi() % 2
	
	var _type = gv.Objective.BREAK if roll == 0 else gv.Objective.HOARD
	
	var duration = randi() % 20 + 10 # 10-30
	
	obj = Objective.new(_type, giver, str(duration))
	
	generateRandomRewards(25)

func construct_random_buy_upgrade():
	
	var selected_upgrade = fixKeyAndGetSurplus()
	setRandomGiver()
	
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, selected_upgrade)
	
	generateRandomRewards(30)

func construct_random_reset():
	#note untested
	setRandomGiver()
	
	obj = Objective.new(gv.Objective.RESET, "")
	
	generateRandomRewards(100)

func construct_random_max_fuel():
	
	var selected_lored = fixKeyAndGetSurplus()
	giver = selected_lored
	
	obj = Objective.new(gv.Objective.MAXED_FUEL_STORAGE, selected_lored)
	
	generateRandomRewards(0)

func construct_random_joy_or_grief():
	
	setRandomGiver()
	
	var roll = randi() % 10
	var resource = "grief" if roll < 2 else "joy"
	var count = str(randi() % 2 + 3)
	
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, resource, count)
	
	generateRandomRewards(60)

#   -   -   -   -   -   -   -   -   -   -

func fixKeyAndGetSurplus() -> String:
	var split = key.split(":")
	var surplus = split[1]
	key = split[0]
	print_debug("surplus: ", surplus, "; key: ", key)
	return surplus

func setRandomGiver():
	giver = gv.list.lored["active"][randi() % gv.list.lored["active"].size()]

func randomLORED() -> String:
	return gv.list.lored["active"][randi() % gv.list.lored["active"].size()]

func randomResource() -> String:
	return gv.list["unlocked resources"][randi() % gv.list["unlocked resources"].size()]

func generateRandomRewards(reward_mod := 0.0):
	
	reward_mod = 10 + reward_mod
	reward_mod *= rand_range(0.5,1.5)
	
	var reward_size := 1
	
	var roll = rand_range(1, 100)
	if roll > 75:
		reward_size = 2
	
	for i in reward_size:
		
		var resource = randomResource()
		var amount: Big
		
		if gv.isStage1Or2LORED(resource):
			amount = Big.max(Big.new(reward_mod).m(rand_range(0.5,1.5)).m(Big.max(gv.g[resource].net(true, false)[0], 1)), 1.0)
		
		amount.roundDown()
		
		if i == 1 and resource == rew[0].key:
			#print("doubling up on rewards; combining")
			rew[0].amount.a(amount)
		else:
			rew.append(Reward.new(gv.WishReward.RESOURCE, resource, amount.toScientific()))

func generateHelpAndThankText():
	
	var roll: int = randi() % 3
	
	match key:
		#note still need random_reset
		"random_max_fuel":
			match giver:
				"cop":
					match roll:
						0: help_text = "Shucks, fam! I'm out of Coal!"
						1: help_text = "We're out of Coal?! Well, I'm confident we can keep the fire going without it."
						2: help_text = "Coca-Coal, what's happening, bro? Fill me up, baby! No homo."
					thank_text = "Thanks, bro. We're stocked and ready to lock and load!"
				"iron":
					match roll:
						0: help_text = "Ope! I'm out of Coal!"
						1: help_text = "I'm just gonna... pluck... a little bit of Coal! For myself!"
						2: help_text = "Coal me up, Coaler!"
					thank_text = "Thanks, Coal!"
				"copo":
					match roll:
						0: help_text = "Hey, we're out of Coal in the mine, and out of Coal in the game, too! Look at that, boss!"
						1: help_text = "C'mon, now, Coal, you've got it, lad. You're a good worker, see, real good. You can do it, pal."
						2: help_text = "Top us off, now, Coal, baby. Thanks a million."
					thank_text = "Truly righteous, Coal. Well-done, well-done."
				"irono":
					match roll:
						0: help_text = "Coal, are you fucking kidding me? Hurry it up."
						1: help_text = "Are you kidding me? How did I get this low on fuel? Did you upgrade me too quickly? Coal better not have a negative net output. I will [i]FUCK[/i]ing [i]LOSE[/i] my [i]FUCK[/i]ing [i]MIND[/i]. I will [i]FIND YOU[/i]. [i]FUEL ME UP. NOW.[/i]"
						2: help_text = "I have a very important role in this system. Don't you understand? I [i]CAN'T[/i] have low fuel. FIX IT."
					thank_text = "Thanks. Fucking bitch. Make sure it doesn't happen again."
				"coal":
					match roll:
						0: help_text = "Just give me a sec, I'll topped off in a flash."
						1: help_text = "Heeheeeee, I literally have priority over everyone else when it comes to fueling up. THAT'S RIGHT, YOU SICK FUCKS. NO MATTER HOW MUCH YOU TAKE, I'LL [i]ALWAYS[/i] BE ABLE TO HIT MAX FUEL. Oh! Gosh, I lost it for just a bit, there! Tee hee. Sorry!"
						2: help_text = "Yup, yup! Won't take me but a moment."
					thank_text = "That's what I'm talking about, baby! Woo!"
				"stone":
					match roll:
						0: help_text = "Yo, Coal, help me out, bro!"
						1: help_text = "C'mon, Coal, you've got it!"
						2: help_text = "Just gotta get filled up real quick!"
					thank_text = "Whew! :)"
		"random_joy_or_grief":
			match obj.key:
				"grief":
					match giver:
						"cop":
							thank_text = "Oh, never mind! It all worked out!"
							match roll:
								0: help_text = "This site was already reserved? Oh..."
								1:
									help_text = "I envisioned a future where there were no trees, no campsites. The air was poisonous. The bug balance of life was fucked up. Farm food rotted, billions died. Marshmallow factories went bankrupt, as there were no campers to buy marshmallows. [i]S'mores[/i]... more like [i]n'mores[/i]. We followed soon after. I was the only one left, in a desert, my lips chapped, unable to move, as the lack of any moisture left my skin taut and crusty. I sat before a circle of rocks, a rod in my hand... with no wood for a fire, nothing stuck on the rod, and no one to share any of it with anyway. I waited for death, but it never came."
									thank_text = "In truth, I died when those factories went under. I am not [i]a'live[/i] without [i]s'mores[/i]. But, it's okay. In real life, people wouldn't stop buying marshmallows, even if all the trees were gone. ...Right?"
								2: help_text = "We have to go back to town for toilet paper? ... :("
						"iron":
							match roll:
								0: help_text = "Awh, shucks! Grief? Why am I Wishing for this again?"
								1: help_text = "Hey, ban that Griefer! Wait, it's me?!"
								2: help_text = "Don't worry, friends, it will only hurt for a little while. Just a little while."
							thank_text = "Oh, thank the Lord that's through."
						"copo":
							match roll:
								0: help_text = "Used to it, boss, used to it."
								1: help_text = "If you want Grief, just talk to the women and children left behind by our lost workers."
								2: help_text = "Oh, sure, boss, we can fix you up with some Grief, no problem, no problem at all. See, just hang around a minute, boss, maybe two, and another of us will turn up dead. You wait and see, just you wait and see, there, bossy boss, I'll mark my job on it. Er.. actually, boss, scratch that last comment from the record."
							thank_text = "Oh, look, boss, more Grief. What a surprise."
						"irono":
							match roll:
								0: help_text = "YEESSSSSS. O, HOW I'VE WAITED FOR THIS MOMENT."
								1: help_text = "EACH STEP HAS LED TO THIS WISH. PLEASE DON'T DISCARD IT. BWWWAAAA HEAHUEAHUWA!!! [i]FEEEEEEL[/i] THE PAIN!"
								2: help_text = "Oh, wow. I'm gonna [i][CENSORED][/i]."
							thank_text = "HAHAHAhe-w--whuh?! It's over? No! NOooo!!! That's it?! I waited all this time for just " + obj.required_count.toString() + " Grief?!\n\nWell, I'll just take out my disappointment on this iron ore deposit. [i]DIE"
						"coal":
							match roll:
								0: help_text = "THAAAAAAAAT'S IT. Y'AAAALL CAN DIE. JUST DIE!"
								1: help_text = "NO MORE FUCKING FUN. NO. NOT MORE YOU FUCKERS."
								2: help_text = "I'VE HAD IT WITH YOU MISERABLE SHITHEADS. THIS IS WHAT YOU DESERVE."
							thank_text = "Golly, did I say all that? Sorry! Tee hee!"
						"stone":
							match roll:
								0: help_text = "I'm sick of you guys messing with my rocks."
								1: help_text = "Mwuahuwahwa >:D"
								2: help_text = "Behold! Dr. Confusion is back in town, to cause misery to everyone!"
							thank_text = "Okay, sorry, but not that sorry."
				"joy":
					match giver:
						"cop":
							match roll:
								0: help_text = "You want to talk about Joy? There was an extra piece of graham cracker in the bottom of the box."
								1: help_text = "Let's en[i]joy[/i] some s'mores! Ha, ahah! What? Someone already made that joke?"
								2: help_text = "Squad--now's our chance! Go Joy!"
							thank_text = "Wooo! I'm back! Who's hungry?!"
						"stone":
							thank_text = "Good job!"
							match roll:
								0: help_text = "If you guys want Joy so much, just pick up some rocks! Trust me!"
								1:
									help_text = "Oh, we need Joy?! Uh--wait. Um... Do you want to hear a joke about ghosts?"
									thank_text = "That's the spirit."
								2: help_text = "Joyyyyy. Yup! On it!"
						"copo":
							match roll:
								0: help_text = "All right, boss, it's been a good long while since the lads had some of this [i]Joy[/i], now, see? Let's hop on it real quick like, see!"
								1: help_text = "Huh? Boss--[i]Joy?[/i] What's that?"
								2: help_text = "All right, now, lads, listen up--Big Wig's comin' down from the capital, see, and we've got to act real Joyous-like if we're to have any hope of scoring those nickel raises we've been pining for, you hear? Remember, now:\n[i]Bok choy-busboys' ploy for employ leaves their wallets coy, you know,\nso deploy bellboy, playboy, albeit decoy, Joy, for dough.[/i]"
							thank_text = "Well carry me out with the tongs, boss, that Joy was wicked, real wicked!"
						"irono":
							match roll:
								0: help_text = "In order for there to be misery, there must first exist Joy."
								1: help_text = "Without Joy, torture is meaningless."
								2: help_text = "Joy and Grief are but two emotions on the coin of our brains, except our brains are full of coins. Wait, does that make any cents?"
							thank_text = "JOY-TIME OVER."
						"coal":
							match roll:
								0: help_text = "Let's see some Joy!"
								1: help_text = "C'mon Joy!"
								2: help_text = "Let's en[i]joy[/i] ourselves :D"
							thank_text = "Sweet."
						"iron":
							match roll:
								0: help_text = "Let's spread Joy!"
								1: help_text = "Yay, Joy!"
								2: help_text = "Joy!!"
							thank_text = "Good job."
		"random_buy_upgrade":
			match giver:
				"cop":
					match roll:
						0: help_text = "We should have upgraded campsites!"
						1: help_text = "Okay, okay. Let's get an Upgrade, boys!"
						2: help_text = "Um... yep! I want this one!"
					thank_text = "The power of game mechanics in action!"
				"iron":
					match roll:
						0: help_text = "Does this Upgrade help me make toast?"
						1: help_text = "Let's get this one!"
						2: help_text = "C'mon, guys! Upgrade time!"
					thank_text = "Woo-hoo!!"
				"copo":
					match roll:
						0: help_text = "I see you figured out all about Upgrades, boss! Way to go, pal."
						1: help_text = "This one, see, this one--what an [i]Upgrade[/i], boss! This will be [i]huge[/i], boss, [i]huge[/i]!"
						2: help_text = "I'd take an upgrade to our air conditioning, life and health insurance, wages, and hours, boss, but this Upgrade is good, too!"
					thank_text = "Slick, boss, real slick."
				"irono":
					match roll:
						0: help_text = "Should have upgraded my weapon."
						1: help_text = "Would rather upgrade my kill count."
						2: help_text = "Oh, sure, let's get [i]" + gv.up[obj.key].name + "[/i] out of all of the available Upgrades. Why this one? Who knows? Who cares. Just buy it, we know you're going to."
					thank_text = "Mwahahaha."
				"coal":
					thank_text = "Yay! Back to work. :)"
					match roll:
						0: help_text = "Yay Upgrades!"
						1:
							help_text = "CAN'T YOU BUY AN UPGRADE THAT BENEFITS [i]ME?!"
							thank_text = "Tee hee. I was only joking around! Kind of! Hee hee."
						2: help_text = "Can't wait to get this one!"
				"stone":
					match roll:
						0: help_text = "Upgrades are somewhat as cool as rocks."
						1: help_text = "Well, more Upgrades, more Stone! Probably!"
						2: help_text = "Let's... uprade our passports?"
					thank_text = "Yay."
		"random_collect":
			match giver:#copo respects coal
				"cop":
					match obj.key:
						"cop":
							help_text = "IT'S ALL ABOUT ME, BABY, THAT'S WHAT I'M SAYIN, HELL YEAH, BOY! LET ME STRUT MY STUFF, HOMIE."
							thank_text = "Yo I killed it. Hell yeah."
						"iron":
							help_text = "Yoooo--that's my fam, dude--I mean, dude, my dude, fam!"
							thank_text = "That's what I'm smokin', dude fam!"
						"copo":
							help_text = "My son! My beloved baby! Yes, help him out!"
							thank_text = "Heck yes!"
						"irono":
							help_text = "Uh... can we not talk about him?"
							thank_text = "Anyway."
						"coal":
							help_text = "Did someone say Coal?"
							thank_text = "Huh?"
						"stone":
							help_text = "Stone--you'd be perfect for finding firewood. Would you, could you?"
							thank_text = "Oh. Well, then! Fine."
				"iron":
					match obj.key:
						"cop":
							help_text = "My best friend! Send him some love, y'all."
							thank_text = ":) Yeah!"
						"iron":
							help_text = "Heheheh... [i]HEHEHEHHEHHHHH!!"
							thank_text = "Aw. It was nice while it lasted, everybody!"
						"copo":
							help_text = "Oh, whoa, [i]whoa, WHOA[/i]! Talk about [i]Stone[/i] working hard--[i]LOOK AT THIS DUDE[/i]! SEND SOME HELP DOWN THERE!"
							thank_text = "Oh, it didn't matter? He's going to work there until he dies, leaving his family in debt? I see. Rough time, early 1900s, real rough, see, boss?\nOops, what was that? Did I catch something?"
						"irono":
							help_text = "Ugh. The [i]Boromir when you were 10 years old seeing the movie for the first time and just thinking Boromir was Walmart-Aragorn[/i] of this game. What a creep."
							thank_text = "Hold on. You're telling me Iron Ore sees me as Aragorn?\n\nGoddamn, that's awkward."
						"coal":
							help_text = "Let's help out Coal!"
							thank_text = "Hooray!"
						"stone":
							help_text = "Ah, that's the stuff. Stone works hard!"
							thank_text = "I'm happy for him!"
				"copo":
					match obj.key:
						"cop":
							help_text = "Nononono-not more Copper, lads, we're good."
							thank_text = "I SAID WE DIDN'T NEED MORE COPPER, LADS. Now a fire's started. See, that's now fixing to consume what little oxygen we have left down here, boss. Yep, takes a real man to brave these absolute bullshit work conditions, boss. Complete and total, unspeakably-bullshit work conditions. Just have Iron Ore shoot me now, boss, just have him shoot me now."
						"iron":
							help_text = "Need more Iron for the supports in the mine, here, boss, need it quick."
							thank_text = "JEREMY, PUT YOUR HARD HAT BACK ON, SEE. I know it's hard to breathe, Jeremy, real hard. But until the earth above is is properly supported, the hat there increases your chances of survival by 1% in the unlikely (but actually likely, see) event of a complete collapse of the tunnel. All right, now, let's get these supports set up, Jeremy. There's a good lad. Boy's only 17 years old, boss, 17. Brings a tear to my eye, boss. I'll make sure he has a Bud Light 'fore the sun sets, boss. Get it, boss? We ain't seen the sun in years, boss. That's a classic joke, see, real classic. He ain't never gonna get that Bud Light, boss. We're all gonna die down here, for $1.70 per day, boss. That's a historically accurate number, boss, look it up. It's fucked up down here, real fucked up."
						"copo":
							help_text = "Ho-ho, boss, ho-ho! Now we're talking. While we're on the subject, I think it's only fair this Wish become infinitely repeatable, seeing as I'm a slave to work and will likely die in the mine before I quit, see."
							thank_text = "Oh, alright, then, boss, alright. Fine with me, I'm used to it, see--get declined for healthcare every year, boss."
						"irono":
							help_text = "Unfortunately, I am seen as the brother or equal of this one, see, and that just ain't right. No, it's not right at all, boss, not right at all, boss, at all, boss, all boss.\nWhoa, I just blacked out, there, boss, am I okay?"
							thank_text = "This fat head would ricochet-murder at least 5 workers in the mine, here, shootin' wild-like like that."
						"coal":
							help_text = "Now, see this one here, boss? This one's the only one who could make it in the mine, here, boss. He's tough, real tough. Of course, I'd never want him to work here. No, this mine should be shut down. But a man's gotta do what a man's gotta do, see?"
							thank_text = "Oh, right! Coal, good job, there, that's real swell. Cherish the sunlight, now."
						"stone":
							help_text = "You're cute, Stone, real cute."
							thank_text = "That's sweet, Stone, real sweet."
				"irono":
					match obj.key:
						"cop":
							help_text = "Fuck that guy. He's a stupid fuck, those aren't s'mores."
							thank_text = "All right. Moving on."
						"iron":
							help_text = "Iron LORED. I follow you, my brother. My captain. My king."
							thank_text = "You bow to no one."
						"copo":
							help_text = "He is putting entirely too much effort into killing that ore deposit. I feel like I'm getting calluses just [i]hearing[/i] him whack away over there. Plus, he talks too much."
							thank_text = "Oof! Well, he's still going. Good on him! [i]I[/i] choose to work [i]smarter[/i]."
						"irono":
							help_text = "I'm... already.. what? I [i]obviously[/i] want more Iron Ore. How come I can even Wish for this? I'm a psychopath, and even I think something is up here. What would happen if you discarded this Wish? Why would you even do that? I'm not going to stop. I'm [i]never[/i] going to stop. You know what? I don't care. Discard it. See what happens. Go on. Do it. I double-homicide-dare you."
							thank_text = "Okay. Whatever. You'll get free random resources out of thin air for not lifting a fucking finger, as if that makes any goddamn sense. Take it to the bank, you three-dimensional fuck. If I could aim out of the screen and at you, I would."
						"coal":
							help_text = "Yes. [i]JAB[/i] that shovel in, real deep."
							thank_text = "EXCELLENT."
						"stone":
							help_text = "Stone, you're next."
							thank_text = "I'm coming for you, Stone. Just... after this Iron Ore deposit actually deteriorates."
				"coal":
					match obj.key:
						"cop":
							help_text = "Copper."
							thank_text = "Thank."
						"iron":
							help_text = "All right, team. Go all in on Iron!"
							thank_text = "That was okay."
						"copo":
							help_text = "Copper Ore's mine looks scary."
							thank_text = "He did it!"
						"irono":
							help_text = "Iron Ore's good for something, I guess!"
							thank_text = "Yup!"
						"coal":
							help_text = "THAT'S GODDAMN RIGHT. WE NEED MORE COAL! YOU ALL WON'T FUCKING GIVE ME A SECOND'S BREAK!"
							thank_text = "Oops! Excuse me! Hee hee."
						"stone":
							help_text = "More Stone, more Coal!"
							thank_text = "Good job, team! I mean, Stone."
				"stone":
					match obj.key:
						"cop":
							help_text = "That stuff looks delicious!!! And part-rock!!!"
							thank_text = "Mmmm! :)"
						"iron":
							help_text = "MORE IRON COULD EVENTUALLY MEAN MORE STONE! LET'S DO IT!"
							thank_text = "YEAHH!!"
						"copo":
							help_text = "Oh, okay! More Copper Ore! Yeah!"
							thank_text = "Yay!"
						"irono":
							help_text = ":( Iron Ore keeps shooting rocks :("
							thank_text = ":("
						"coal":
							help_text = "Let's get some more Coal!"
							thank_text = "Yay :)"
						"stone":
							help_text = "We need more rocks, duh!"
							thank_text = "[i]Wooo!!! Stones!!!![/i]"
		"random_break_or_hoard":
			match obj.type:
				gv.Objective.BREAK:
					match giver:
						"cop":
							match roll:
								0: help_text = "I'll be behind that tree over there."
								1: help_text = "Shoot! Oh, no, guys, it's okay. I've got more graham crackers in the car."
								2: help_text = "I've been sitting by this fire for ages. I might be developing burn-tissue."
							thank_text = "Wooo! I'm back! Who's hungry?!"
						"iron":
							match roll:
								0: help_text = "I'm tired!"
								1: help_text = "My toaster is overheating. Can we let it take a break?"
								2: help_text = "I need to go find some band-aids for my forehead."
							thank_text = "All-righty! Back to work!"
						"copo":
							match roll:
								0: help_text = "Listen, boss, listen. I'm tired, all right? I'm real tired. I can't do this no more. I need a break, boss. Gotta have it."
								1: help_text = "Boss, I'm fed up, real fed up. If I go on like this, I won't make it, see, I really won't make it. I need to relax."
								2: help_text = "Breather, boss, breather! Need to take five. You'll barely notice I was gone, boss, truly!"
							thank_text = "Hoo-wee, boss, hoo-wee! What a relief! That was definitely worth it, boss, you'll see. Production will go up seven-hundred percent, boss, [i]seven-hundred percent[/i]! Don't quote me on that."
						"irono":
							match roll:
								0: help_text = "Must rest."
								1: help_text = "Need more shells."
								2: help_text = "Require reprieve."
							thank_text = "BACK TO [i]MURDERING![/i]"
						"coal":
							match roll:
								0: help_text = "My body aches!"
								1: help_text = "I hope the others will be fine, but I really need to take a moment."
								2: help_text = "I'd love to take a second to relax!"
							thank_text = "Yay! Back to work. :)"
						"stone":
							match roll:
								0: help_text = "My back hurts."
								1: help_text = "Yeah, rocks, but, you know--my legs are about to give out!"
								2: help_text = "Can I get a break so I can think about the best way to pick up rocks?"
							thank_text = "Whew!"
				gv.Objective.HOARD:
					match giver:
						"cop":
							match roll:
								0: help_text = "There's plenty to come, wait your turn. This batch looks especially good!"
								1: help_text = "Wait, can I just--this one was cooked perfectly. You can have the next two, I promise!"
								2: help_text = "It's... uh... winter is coming? I need to stockpile. Yep!"
							thank_text = "Okay, okay! Everyone hop in!"
						"iron":
							match roll:
								0: help_text = "I'm somewhat, slightly, partially [i]starving to death[/i], so I'm going to need to eat some of these."
								1: help_text = "Toaster and I have a unique relationship, but in the end it is [i]our[/i] relationship. We can't be swinging every moment of every day!"
								2: help_text = "Ummm... nah. This is mine."
							thank_text = "Okay! That was fun, but I missed sharing with y'all."
						"copo":
							match roll:
								0: help_text = "All right, now, listen up. You've all had just about enough of this here dough. No, I don't want to hear it. I'm working my hands near down to the bone, see, and I think I deserve to keep a little of what is really mine. You all get it, don'tcha?"
								1: help_text = "Boss, don't let them take anymore from me. I've had it up to here, boss, up to here!"
								2: help_text = "Now, you've all had yours, see, but now it's time I had mine. Fair's fair, and what's mine is mine, see? It's only right, now, it's only right."
							thank_text = "All right, now, friends, you've been mighty patient, I've seen you be mighty patient. You can have at it again. You, too, boss, you too."
						"irono":
							match roll:
								0: help_text = "ALL MINE."
								1: help_text = "I GOT YOU FOR THREE MINUTES. THREE MINUTES OF [i]PLAYTIME[/i]."
								2: help_text = "[i]No one to save you, now.[/i]"
							thank_text = "You're safe... for now."
						"coal":
							match roll:
								0: help_text = "THAT'S IT! YOU'VE ALL HAD ENOUGH! [i]I'M FUCKING SICK OF IT!"
								1: help_text = "NO MORE FUCKING COAL FOR YOU MOTHERFUCKERS, GODDAMNIT. [i]I DON'T HAVE ENOUGH FOR MYSELF!"
								2: help_text = "ABSOLUTELY NO MORE COAL FOR [i]ANNNNNYYYYY[/i] OF YOU STUPID FUCKERS. [i]I'M NOT DOING THIS SHIT ANYMORE[/i]."
							thank_text = "Hee hee! Sorry about that. I didn't mean it. Tee hee! :)"
						"stone":
							match roll:
								0: help_text = "I found these rocks, so they're mine!"
								1: help_text = "I don't feel like sharing."
								2: help_text = "I just want a chance to feel these ones."
							thank_text = "All right, fine! I don't really mind sharing, anyway."
