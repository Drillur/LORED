class_name Wish
extends RefCounted



var saved_vars := [
	"type",
	"ready_to_turn_in",
	"objective",
	"giver",
	"lucky_multiplier",
	"help_icon_path",
	"thank_icon_path",
	"reward_count",
]


func load_started() -> void:
	kill()



class Reward:
	
	var saved_vars := []
	
	enum Type {
		CURRENCY,
		NEW_LORED,
		JUST_TEXT,
		UPGRADE_MENU,
		STAGE,
		INCREASED_RANDOM_WISH_LIMIT,
	}
	
	signal completed
	
	var type: int
	var key: String
	var text: String
	
	var amount: Big
	var object_type: int
	
	
	func _init(_type: int, data: Dictionary) -> void:
		type = _type
		key = Type.keys()[type]
		
		call("init_" + key, data)
	
	
	func init_CURRENCY(data: Dictionary) -> void:
		object_type = data["object_type"]
		if data["amount"] is Big:
			amount = data["amount"]
		else:
			amount = Big.new(data["amount"])
		text = (wa.get_currency(object_type).details.color_text % "+%s ") + wa.get_icon_and_name_text(object_type)
	
	
	func init_NEW_LORED(data: Dictionary) -> void:
		object_type = data["object_type"]
		var lored = lv.get_lored(object_type)
		text = lored.details.icon_and_colored_name + ", [i]" + lored.details.color_text % lored.details.get_title()
	
	
	func init_INCREASED_RANDOM_WISH_LIMIT(data: Dictionary) -> void:
		amount = Big.new(data["amount"])
		text = "+" + amount.text + " Random Wish Limit"
	
	
	func init_UPGRADE_MENU(data: Dictionary) -> void:
		object_type = data["object_type"]
		var upgrade_menu: UpgradeMenu = up.get_upgrade_menu(object_type)
		if object_type == UpgradeMenu.Type.NORMAL:
			text = "[img=<15>]res://Sprites/Hud/upgrades.png[/img] Upgrade Menu"
			text = upgrade_menu.details.color_text % text
		else:
			text = upgrade_menu.details.icon_and_colored_name
	
	
	func init_STAGE(data: Dictionary) -> void:
		object_type = data["object_type"]
		var stage: Stage = gv.get_stage(object_type) as Stage
		text = stage.details.color_text % stage.details.icon_and_name_text
	
	
	func init_JUST_TEXT(data: Dictionary) -> void:
		text = data["text"]
	
	
	
	func save_rewards() -> void:
		if not "type" in saved_vars:
			saved_vars = [
				"type",
				"key",
				"amount",
				"object_type",
			]
	
	
	
	func receive() -> void:
		if has_method("receive_" + key):
			call("receive_" + key)
	
	
	func receive_CURRENCY() -> void:
		wa.add(object_type, amount)
	
	
	func receive_NEW_LORED() -> void:
		lv.unlock_lored(object_type)
	
	
	func receive_INCREASED_RANDOM_WISH_LIMIT() -> void:
		wi.random_wish_limit += 1
	
	
	func receive_UPGRADE_MENU() -> void:
		up.unlock_menu(object_type)
	
	
	func receive_STAGE() -> void:
		gv.unlock_stage(object_type)
		if object_type == 2:
			gv.unlock_stage(1)
	
	
	
	func has_text() -> bool:
		return text != ""
	
	
	func get_text() -> String:
		if not has_method("get_text_" + key):
			return text
		return call("get_text_" + key)
	
	
	func get_text_CURRENCY() -> String:
		return text % amount.text



class Objective:
	
	var saved_vars := [
		"progress",
	]
	
	
	enum Type {
		LOADED_OBJECTIVE,
		LORED_LEVELED_UP,
		UPGRADE_PURCHASED,
		ACCEPTABLE_FUEL,
		COLLECT_CURRENCY,
		SLEEP,
	}
	
	signal completed
	
	var type: int:
		set(val):
			type = val
			key = Type.keys()[val]
	var key: String
	var icon: Texture
	var icon_path: String:
		set(val):
			icon_path = val
			icon = load(icon_path)
	var color: Color
	var text: String
	
	var progress: ValuePair
	
	var object_type: int
	var x: int
	
	var lored_was_already_asleep := false
	
	
	
	func _init(_type: int, data: Dictionary) -> void:
		type = _type
		
		call("init_" + key, data)
		
		progress.change_base(0)
		progress.set_to(0)
	
	
	func init_LOADED_OBJECTIVE(_data: Dictionary) -> void:
		progress = ValuePair.new(1)
	
	
	func init_LORED_LEVELED_UP(data: Dictionary) -> void:
		progress = ValuePair.new(1)
		object_type = data["object_type"]
		x = data["x"]
		icon_path = lv.get_icon(object_type).get_path()
		color = lv.get_color(object_type)
		text = "Level Up"
	
	
	func init_ACCEPTABLE_FUEL(data: Dictionary) -> void:
		progress = ValuePair.new(75)
		object_type = data["object_type"]
		icon_path = lv.get_icon(object_type).get_path()
		color = lv.get_color(object_type)
		text = lv.get_lored_name(object_type) + " 75% Fuel"
	
	
	func init_COLLECT_CURRENCY(data: Dictionary) -> void:
		progress = ValuePair.new(data["amount"])
		object_type = data["object_type"]
		icon_path = wa.get_icon(object_type).get_path()
		color = wa.get_color(object_type)
		text = "Collect " + wa.get_currency_name(object_type)
	
	
	func init_SLEEP(data: Dictionary) -> void:
		progress = ValuePair.new(data["amount"])
		object_type = data["object_type"]
		lored_was_already_asleep = lv.get_lored(object_type).asleep.get_value()
		icon_path = lv.get_icon(object_type).get_path()
		color = lv.get_color(object_type)
		text = "Sleep"
	
	
	func init_UPGRADE_PURCHASED(data: Dictionary) -> void:
		progress = ValuePair.new(1)
		object_type = data["object_type"]
		icon_path = up.get_icon(object_type).get_path()
		color = up.get_color(object_type)
		text = up.get_upgrade_name(object_type) + " Purchased"
	
	
	
	# - Actions
	
	func save_info() -> void:
		if not "type" in saved_vars:
			saved_vars.append("type")
			saved_vars.append("object_type")
			saved_vars.append("color")
			saved_vars.append("icon_path")
			saved_vars.append("text")
	
	
	func start() -> void:
		if key == "LOADED_OBJECTIVE":
			return
		progress.filled.connect(progress_filled)
		if has_method("already_completed_" + key) and call("already_completed_" + key):
			progress.set_to_percent(1)
		else:
			if has_method("stop_"  + key):
				connect("completed", get("stop_" + key))
			call("start_" + key)
	
	
	func progress_filled() -> void:
		completed.emit()
	
	
	
	func start_LORED_LEVELED_UP() -> void:
		lv.get_lored(object_type).leveled_up.connect(update_LORED_LEVELED_UP)
	
	
	func update_LORED_LEVELED_UP(_level: int) -> void:
		progress.add(1)
		lv.get_lored(object_type).leveled_up.disconnect(update_LORED_LEVELED_UP)
	
	
	func already_completed_LORED_LEVELED_UP() -> bool:
		return lv.get_lored(object_type).level >= x
	
	
	
	func already_completed_ACCEPTABLE_FUEL() -> bool:
		return lv.get_lored(object_type).fuel.get_current_percent() >= 0.75
	
	
	func start_ACCEPTABLE_FUEL() -> void:
		lv.get_lored(object_type).fuel.connect("changed", update_ACCEPTABLE_FUEL)
		update_ACCEPTABLE_FUEL()
	
	
	func update_ACCEPTABLE_FUEL() -> void:
		progress.set_to(lv.get_lored(object_type).fuel.get_current_percent() * 100)
	
	
	func stop_ACCEPTABLE_FUEL() -> void:
		lv.get_lored(object_type).fuel.disconnect("changed", update_ACCEPTABLE_FUEL)
		
	
	
	func start_COLLECT_CURRENCY() -> void:
		wa.get_currency(object_type).connect("increased", update_COLLECT_CURRENCY)
	
	
	func update_COLLECT_CURRENCY(amount_increased: Big) -> void:
		progress.add(amount_increased)
		if progress.full:
			wa.get_currency(object_type).disconnect("increased", update_COLLECT_CURRENCY)
	
	
	
	func start_SLEEP() -> void:
		lv.get_lored(object_type).spent_one_second_asleep.connect(update_SLEEP)
	
	
	func update_SLEEP() -> void:
		progress.add(1)
		if progress.full:
			lv.get_lored(object_type).spent_one_second_asleep.connect(update_SLEEP)
			wake_up_sleeping_lored()
	
	
	
	func wake_up_sleeping_lored() -> void:
		if type == Type.SLEEP and not lored_was_already_asleep:
			lv.get_lored(object_type).dequeue_sleep()
	
	
	func already_completed_UPGRADE_PURCHASED() -> bool:
		return up.is_upgrade_purchased(object_type)
	
	
	func start_UPGRADE_PURCHASED() -> void:
		up.get_upgrade(object_type).purchased.became_true.connect(update_UPGRADE_PURCHASED)
	
	
	func update_UPGRADE_PURCHASED() -> void:
		progress.set_to(1)
		up.get_upgrade(object_type).purchased.became_true.disconnect(update_UPGRADE_PURCHASED)
	
	
	
	# - Flash Shit
	
	func will_flash_something() -> bool:
		return has_method("flash_" + key)
	
	
	func flash() -> void:
		call("flash_" + key)
	
	
	func flash_LORED_LEVELED_UP() -> void:
		gv.flash(lv.get_vico(object_type).level_up, lv.get_color(object_type))
	
	
	func flash_ACCEPTABLE_FUEL() -> void:
		gv.flash(lv.get_vico(object_type).fuel_bar, lv.get_color(object_type))
	
	
	func flash_SLEEP() -> void:
		gv.flash(lv.get_vico(object_type).sleep, lv.get_color(object_type))



enum Type {
	RANDOM,
	STUFF,
	FUEL,
	COLLECTION,
	UPGRADE_STONE,
	IMPORTANCE_OF_COAL,
	TEST_SLEEP,
	GRINDER,
	JOY,
	JOBS,
	RYE,
	SAND,
	MALIGNANCY,
	SOCCER_DUDE,
	JOY2,
	A_NEW_LEAF,
	WATERBUDDY,
	LIQY,
	GRAMMA,
	WOODY,
	HARDY,
	AXY,
	TREEY,
	JOY3,
	STEELY,
	HORSEY,
	GALEY,
	PAPEY,
	PLASTY,
	CARCY,
	TUMORY,
	MALIGGY,
	CIORANY,
	EASIER,
	AUTOCOMPLETE,
	TO_DA_LIMIT,
}

signal became_ready_to_turn_in
signal just_turned_in
signal just_dismissed
signal just_ended(wish)
signal became_ready_to_start

var type: int
var pair := []
var key: String

var lucky_multiplier := 1.0

var turned_in := false
var ready_to_turn_in := false
var killed := false

var help_text: String
var thank_text: String
var discord_state: String

var help_icon: Texture
var help_icon_path: String:
	set(val):
		help_icon_path = val
		help_icon = load(help_icon_path)
var thank_icon: Texture
var thank_icon_path: String:
	set(val):
		thank_icon_path = val
		thank_icon = load(thank_icon_path)

var giver: int

var rewards := []
var reward_count := 0

var objective: Objective

var vico: Node

var container: VBoxContainer



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	
	SaveManager.connect("load_started", load_started)
	
	call("init_" + key)
	
	objective.connect("completed", objective_completed)
	
	if help_icon == null:
		help_icon_path = "res://Sprites/reactions/Angry.png"
	if thank_icon == null:
		thank_icon_path = "res://Sprites/reactions/Test.png"


func idk(x: float) -> float:
	if x > 50:
		return 1.0
	return (50 - (50 * (1 - exp(-x/5)))) / 10 + 1


func init_RANDOM() -> void:
	giver = lv.get_random_active_lored()
	var obj_key = lv.get_lored(giver).get_wish()
	var obj_type = Objective.Type[obj_key]
	var data := {}
	#var experience_modifier = idk(wi.completed_random_wishes)
	var rewards_modifier := randf_range(10, 30)
	match obj_key:
		"COLLECT_CURRENCY":
			var amount: Big
			var currency: Currency = wa.get_currency(lv.get_lored(giver).wished_currency)
			if currency.produced_by.size() == 0:
				amount = Big.new(randi_range(2, 5))
			else:
				amount = Big.new(currency.gain_rate.get_value())
				var amount_modifier = randf_range(20, 40)
				amount.m(amount_modifier)
				#amount.d(experience_modifier)
			data = {
				"object_type": currency.type,
				"amount": amount.roundDown(),
			}
		"LORED_LEVELED_UP":
			data = {
				"object_type": giver,
				"x": lv.get_level(giver) + 1,
			}
		"SLEEP":
			data = {
				"object_type": giver,
				"amount": round(randi_range(6, 20)),# / experience_modifier),
			}
		"ACCEPTABLE_FUEL":
			data = {"object_type": giver}
		"UPGRADE_PURCHASED":
			data = {"object_type": lv.get_lored(giver).wished_upgrade}
	objective = Objective.new(obj_type, data)
	objective.save_info()
	
	
	var _reward_count = 1
	while randi() % 100 < 40:
		_reward_count += 1
	rewards_modifier /= _reward_count
	lucky_multiplier = 1 + (randf() * _reward_count) # if 7 rewards, x 1-8
	rewards_modifier *= lucky_multiplier
	
	var amounts := {}
	for reward in _reward_count:
		var amount: Big
		var currency: Currency = wa.get_currency(wa.get_weighted_random_currency())
		amount = Big.new(currency.gain_rate.get_value()).m(rewards_modifier).roundDown()
		if amount.less(1):
			amount.set_to(1)
		if currency.type in amounts:
			amounts[currency.type].a(amount)
		else:
			amounts[currency.type] = Big.new(amount)
	for cur in amounts:
		add_reward(
			Reward.new(
				Reward.Type.CURRENCY, {
					"object_type": cur,
					"amount": amounts[cur],
				}
			), true
		)



func init_STUFF() -> void:
	giver = LORED.Type.STONE
	help_text = "I want to pick up rocks, but I'm out of [b]fuel!![/b] Help!"
	var img_text = "[img=<15>]" + gv.TEXTURES["Level"].get_path() + "[/img]"
	help_text += "\n\nClick on Coal's " + img_text + " Level Up button to make him become active!"
	thank_text = "That's the stuff. Thanks!"
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"object_type": LORED.Type.COAL,
		"x": lv.get_level(LORED.Type.COAL) + 1,
	})


func init_FUEL() -> void:
	giver = LORED.Type.COAL
	help_text = "If Stone wants my stuff, I'm happy to share!"
	thank_text = "Glad I could help. :)"
	discord_state = "Getting Stone back on his feet."
	objective = Objective.new(Objective.Type.ACCEPTABLE_FUEL, {
		"object_type": LORED.Type.STONE,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.STONE,
		"amount": 15,
	}))


func init_COLLECTION() -> void:
	giver = LORED.Type.STONE
	help_text = "I'm just going to pick up some of these."
	thank_text = "Rocks are neat."
	discord_state = "Picking up rocks."
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.STONE,
		"amount": 10,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.IRON_ORE,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.COPPER_ORE,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.IRON,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.COPPER,
	}))


func init_IMPORTANCE_OF_COAL() -> void:
	giver = LORED.Type.COAL
	help_text = "Yikes!! Everyone is taking my stuff! No rest for the righteous, I guess!"
	thank_text = "Whew."
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.COAL,
		"amount": 25,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.COAL,
		"amount": 50,
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.IRON,
		"amount": 10,
	}))
	pair.append(Type.UPGRADE_STONE)


func init_UPGRADE_STONE() -> void:
	giver = LORED.Type.IRON
	help_text = "Stone seems like he's got a little much to do. Could you level him up to make it easier on him?"
	thank_text = "Awesome! I bet he's liking that. Thanks :)"
	discord_state = "Getting Stone to Level 2."
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"object_type": LORED.Type.STONE,
		"x": lv.get_level(LORED.Type.STONE) + 1,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.STONE,
		"amount": 50,
	}))
	add_reward(Reward.new(Reward.Type.JUST_TEXT, {
		"text": "LOREDs can sleep!"
	}))
	pair.append(Type.IMPORTANCE_OF_COAL)


func init_TEST_SLEEP() -> void:
	giver = LORED.Type.COPPER
	help_text = "I'm about to introduce you to [b]Upgrades[/b], but first, uh... I'm tired. I want to take a nap."
	thank_text = "Whuh? Whozzat? Where am I?"
	discord_state = "Taking a nap."
	objective = Objective.new(Objective.Type.SLEEP, {
		"object_type": LORED.Type.COPPER,
		"amount": 15,
	})
	add_reward(Reward.new(Reward.Type.UPGRADE_MENU, {
		"object_type": UpgradeMenu.Type.NORMAL
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.COPPER,
		"amount": 15,
	}))


func init_GRINDER() -> void:
	giver = LORED.Type.STONE
	help_text = "Whoa?! Does the GRINDER upgrade work on rocks?"
	thank_text = "This is awesome!"
	discord_state = "Getting Upgrades!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.GRINDER,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.IRON,
		"amount": 30,
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.COPPER,
		"amount": 30,
	}))
	add_reward(Reward.new(Reward.Type.INCREASED_RANDOM_WISH_LIMIT, {
		"amount": 1,
	}))


func init_JOY() -> void:
	giver = LORED.Type.IRON
	help_text = "Hey, it looks like everyone is opening up to you! They're sharing their Wishes! Isn't that nice?"
	thank_text = "Whoa, look! Growth just showed up!"
	discord_state = "Fulfilling wishes!"
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.JOY,
		"amount": 3,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.GROWTH,
	}))


func init_JOBS() -> void:
	giver = LORED.Type.STONE
	help_text = "I noticed that when Growth appeared, you got even more confused that before! I mean, how is any of this working?! Who is taking resources from who? What are each of us capable of?! When will my rock bag get full??!"
	thank_text = "Don't mention it. You're welcome!"
	discord_state = "Crushing dreams!"
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.GRIEF,
		"amount": 3,
	})
	add_reward(Reward.new(Reward.Type.JUST_TEXT, {
		"text": "You can view LOREDs' Jobs and their details!"
	}))
	add_reward(Reward.new(Reward.Type.JUST_TEXT, {
		"text": "You gain access to the Wallet! Hotkey: T"
	}))


func init_RYE() -> void:
	giver = LORED.Type.GROWTH
	help_text = "[b][i]I AM CURRENTLY IN AN [u]UNFORTUNATE[/u] SITUATION."
	thank_text = "[b][i]IT WOULD APPEAR THAT THERE WILL BE [u]NO END[/u] TO MY SUFFERING."
	discord_state = "Witnessing something juicy!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.RYE,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.JOULES,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.CONCRETE,
	}))


func init_SAND() -> void:
	giver = LORED.Type.JOULES
	help_text = "If you really want to progress, you could get this Upgrade over here."
	thank_text = "Yeah, uhh... good job."
	discord_state = "It's getting sandy!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.SAND,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.OIL,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.TARBALLS,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.MALIGNANCY,
	}))


func init_MALIGNANCY() -> void:
	giver = LORED.Type.MALIGNANCY
	help_text = "Heyo! It's grinding time, baby! You'll want this much Malignancy before you " + (up.get_menu_color_text(UpgradeMenu.Type.MALIGNANT) % "Metastaize") + ".\n\nWhat's that, you ask? Teheheheeeee >:D"
	thank_text = "Good luck. Have fun!"
	discord_state = "Approaching their first reset."
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.MALIGNANCY,
		"amount": "3e3",
	})
	add_reward(Reward.new(Reward.Type.UPGRADE_MENU, {
		"object_type": UpgradeMenu.Type.MALIGNANT
	}))


func init_SOCCER_DUDE() -> void:
	giver = LORED.Type.COPPER_ORE
	help_text = "You've got to reset to get this one, boss, see? But, you don't have to reset right now, bossy boss. Do what you want. You're the boss, boss, see, boss?"
	thank_text = "Wicked, boss, real wicked. We're rolling with the big cats, now, boss!"
	discord_state = "About to Metastasize for the first time!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.SOCCER_DUDE,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.MALIGNANCY,
		"amount": "1e3",
	}))


func init_JOY2() -> void:
	giver = LORED.Type.IRON
	help_text = "This one just came in straight from the developer himself! No, really! Don't believe me? Ask him!"
	thank_text = "Hey, the developer sent a message for you, as if I were some kind of Post LORED: \"You're a big stinky winky.\"\n\nI swear! It was him!! Not me! I can't believe he made me say that."
	discord_state = "On their second run of Stage 1!"
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.JOY,
		"amount": 10,
	})
	add_reward(Reward.new(Reward.Type.INCREASED_RANDOM_WISH_LIMIT, {
		"amount": 1,
	}))


func init_A_NEW_LEAF() -> void:
	giver = LORED.Type.WATER
	help_text = "Whoa!\n\nMaybe, Trees, look! There's others out there! :0 There are so many of them! Whoooooooooooa! Whaaaaat?! !!!!"
	thank_text = "It's really great to meet you!! I'm Water.\n\nHey, come here! I want to show you my pool!"
	discord_state = "About to meet a new group of LOREDs!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.UPGRADE_NAME,
	})
	add_reward(Reward.new(Reward.Type.INCREASED_RANDOM_WISH_LIMIT, {
		"amount": 1,
	}))



func add_reward(reward: Reward, save_rewards := false) -> void:
	rewards.append(reward)
	reward_count = rewards.size()
	if save_rewards:
		reward.save_rewards()
		if not "rewards" in saved_vars:
			saved_vars.append("rewards")



# - Actions

func start() -> void:
	if discord_state != "":
		gv.update_discord_state(discord_state)
	objective.start()



func objective_completed() -> void:
	ready_to_turn_in = true
	emit_signal("became_ready_to_turn_in")



func turn_in() -> void:
	for rew in rewards:
		rew.receive()
	wa.add(Currency.Type.JOY, 1)
	turned_in = true
	end()


func dismiss() -> void:
	objective.wake_up_sleeping_lored()
	wa.add(Currency.Type.GRIEF, 1)
	emit_signal("just_dismissed")
	end()


func kill() -> void:
	objective.wake_up_sleeping_lored()
	if is_instance_valid(vico):
		vico.queue_free()
	killed = true
	end()


func end() -> void:
	just_ended.emit(self)



func flash_something() -> void:
	if objective.will_flash_something():
		objective.flash()
	else:
		gv.flash(vico)



# - Get

static func get_key(_type: int) -> String:
	return Type.keys()[_type]


func get_color() -> Color:
	return objective.color


func get_icon() -> Texture:
	return objective.icon


func get_reward_texts() -> Array:
	var arr = []
	for rew in rewards:
		if rew.has_text():
			arr.append(rew.get_text())
	return arr


func get_currency_rewards() -> Dictionary:
	var data = {}
	for rew in rewards:
		if rew.type == Reward.Type.CURRENCY:
			data[rew.object_type] = rew.amount
	data[Currency.Type.JOY] = Big.new(1)
	return data


func get_dismissal_currencies() -> Dictionary:
	var data = {}
	# maybe add something here? prob not. whatever!
	data[Currency.Type.GRIEF] = Big.new(1)
	return data


func has_pair() -> bool:
	return pair.size() > 0


func has_rewards() -> bool:
	return reward_count > 0


func is_main_wish() -> bool:
	return type > 0


