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
]


func load_started() -> void:
	kill()


func load_finished() -> void:
	if is_random_wish():
		for reward in rewards:
			reward.save_rewards()



class Reward:
	
	var saved_vars := []
	
	enum Type {
		CURRENCY,
		NEW_LORED,
		JUST_TEXT,
		UPGRADE_MENU,
		STAGE,
		INCREASED_RANDOM_WISH_LIMIT,
		AUTOMATED_SLEEP,
		WISH_AMOUNT_DIVIDER,
		AUTO_WISH_TURNIN,
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
	
	
	func init_AUTOMATED_SLEEP(_data: Dictionary) -> void:
		text = "Automated Sleep"
	
	
	func init_WISH_AMOUNT_DIVIDER(data: Dictionary) -> void:
		amount = Big.new(data.amount)
		text = "[b]%s[/b]x Easier Wishes" % str(data.amount)
	
	
	func init_AUTO_WISH_TURNIN(_data: Dictionary) -> void:
		text = "Automatic Wish Completion"
	
	
	
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
	
	
	func receive_AUTOMATED_SLEEP() -> void:
		wi.automated_sleep = true
	
	
	func receive_WISH_AMOUNT_DIVIDER() -> void:
		wi.wish_amount_divider *= amount.toFloat()
	
	
	
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
		if progress.is_full():
			completed.emit()
			return
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
		var lored = lv.get_lored(object_type) as LORED
		lored.spent_one_second_asleep.connect(update_SLEEP)
		if wi.automated_sleep:
			lored.go_to_sleep()
	
	
	func update_SLEEP() -> void:
		progress.add(1)
		if progress.full:
			lv.get_lored(object_type).spent_one_second_asleep.connect(update_SLEEP)
			wake_up_sleeping_lored()
	
	
	
	func wake_up_sleeping_lored() -> void:
		if type == Type.SLEEP and not lored_was_already_asleep:
			lv.get_lored(object_type).wake_up()
	
	
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
	
	SaveManager.load_started.connect(load_started)
	SaveManager.load_finished.connect(load_finished)
	
	call("init_" + key)
	
	objective.completed.connect(objective_completed)
	
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
				var amount_modifier = randf_range(30, 50)
				amount.m(amount_modifier)
				amount.d(wi.wish_amount_divider)
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
				"amount": round(randf_range(8, 22) / wi.wish_amount_divider),# / experience_modifier),
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
	rewards_modifier *= 0.8
	
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
	var a = lv.get_colored_name(LORED.Type.STONE)
	help_text = "%s seems like he's got a little much to do. Could you level him up to make it easier on him?" % a
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
	help_text = "[b]I AM CURRENTLY IN AN [u]UNFORTUNATE[/u] SITUATION."
	thank_text = "[b]IT WOULD APPEAR THAT THERE WILL BE [u]NO END[/u] TO MY SUFFERING."
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
	var a = lv.get_colored_name(LORED.Type.SEEDS)
	var b = lv.get_colored_name(LORED.Type.TREES)
	var c = lv.get_colored_name(LORED.Type.WATER)
	help_text = "Whoa!\n\n%s, %s, look! There's others out there! :0 There are so many of them! Whoooooooooooa! Whaaaaat?! !!!!" % [a, b]
	thank_text = "It's really great to meet you!! I'm %s.\n\nHey, come here! I want to show you my pool!" % c
	discord_state = "About to meet a new group of LOREDs!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.UPGRADE_NAME,
	})
	add_reward(Reward.new(Reward.Type.STAGE, {
		"object_type": Stage.Type.STAGE2,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.WATER,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.SEEDS,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.TREES,
	}))


func init_WATERBUDDY() -> void:
	giver = LORED.Type.WATER
	var lseeds = lv.get_colored_name(LORED.Type.SEEDS)
	thank_text = "Oh, hey, I--that's literally what I was gonna wish for! %s to level 1! That's funny." % lseeds
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"object_type": LORED.Type.SEEDS,
		"x": lv.get_level(LORED.Type.SEEDS) + 1,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.STEEL,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.LIQUID_IRON,
	}))


func init_LIQY() -> void:
	giver = LORED.Type.LIQUID_IRON
	help_text = "Some freaking little freaker keeps throwing iron on my [b]head!!![/b]\n\nSo anyways, I'm making soup."
	thank_text = "Soup."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.STEEL,
		"amount": 3,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.WIRE,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.DRAW_PLATE,
	}))


func init_GRAMMA() -> void:
	giver = LORED.Type.WIRE
	help_text = "[shake rate=20.0 level=5 connected=0]Oooh! Goodness gracious! Look at you![/shake]\n\nNow stop causing a ruckus, you little heathen, and come help me get some wire."
	thank_text = "[shake rate=20.0 level=5 connected=0]Children are so kind.[/shake]"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.STEEL,
		"amount": 25,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.AXES,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.WOOD,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.HARDWOOD,
	}))


func init_WOODY() -> void:
	giver = LORED.Type.WOOD
	var axe = wa.get_currency(Currency.Type.AXES).details.icon_and_colored_name
	var wood = wa.get_currency(Currency.Type.WOOD).details.icon_and_colored_name
	help_text = "Hey! I heard you were strong! Let's fight!\n\nJust kiddin. Hey, can you help me get some %s? I need them to make %s." % [axe, wood]
	thank_text = "Wow, that was fast! Not as fast as me, but pretty good!"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.AXES,
		"amount": 20,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.SAND,
	}))
	pair.append(Type.HARDY)
	pair.append(Type.AXY)


func init_HARDY() -> void:
	giver = LORED.Type.HARDWOOD
	var wd = wa.get_currency(Currency.Type.WOOD).details.icon_and_colored_name
	var hd = wa.get_currency(Currency.Type.HARDWOOD).details.color_text % "hard"
	help_text = "Hiya, stud. Care to help a girl out with some %s? I'll make it %s for you." % [wd, hd]
	thank_text = "Call me later."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.WOOD,
		"amount": 300,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.GLASS,
	}))
	pair.append(Type.WOODY)
	pair.append(Type.AXY)


func init_AXY() -> void:
	giver = LORED.Type.AXES
	var hd = wa.get_currency(Currency.Type.HARDWOOD).details.icon_and_colored_name
	var st = wa.get_currency(Currency.Type.STEEL).details.icon_and_colored_name
	var ax = wa.get_currency(Currency.Type.AXES).details.icon_and_colored_name
	help_text = "I require 0.8 %s and 0.25 %s per cycle. Satisfy these requirements and I will assemble 1.0 %s. If you require further assistance, you can find help in the Help section of your Alaxa app." % [
		hd, st, ax
	]
	thank_text = "Task complete."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.HARDWOOD,
		"amount": 20,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.HUMUS,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.SOIL,
	}))
	pair.append(Type.WOODY)
	pair.append(Type.HARDY)


func init_TREEY() -> void:
	giver = LORED.Type.TREES
	var soil = lv.get_colored_name(LORED.Type.SOIL)
	var soil2 = wa.get_currency(Currency.Type.SOIL).details.icon_and_colored_name
	
	var st = lv.get_colored_name(LORED.Type.STEEL)
	var hd = lv.get_colored_name(LORED.Type.HARDWOOD)
	var wr = lv.get_colored_name(LORED.Type.WIRE)
	var gs = lv.get_colored_name(LORED.Type.GLASS)
	help_text = "Woohoo! There's a ton of friends here, now!! That's CrAzy!!!\n\n%s's here, too!! My favorite thing in the [b]whole void!![/b] I need %s's %s to get [b]stronger!!!![/b]\n\nAlso, listen to this. It's crazy. Those four are in a loop. They all require each other to work. I'm talking about %s, %s, %s, and %s. Each of the four have their own branch. %s is the worst. She has a loop of her own, and I'm not talking about her earrings. More like she's loopy! Ha!! She's got a loop in her own loop. It's super confusing!!! [b]It's crazy!!!" % [
		soil, soil, soil2,st, hd, wr, gs, hd,
	]
	var sl3b = wa.get_currency(Currency.Type.SOIL).details.icon_text
	var sl3 = wa.get_currency(Currency.Type.SOIL).details.color_text % wa.get_currency_name(Currency.Type.SOIL).to_upper()
	thank_text = "[b]YEAH, LET'S GOOOOOO! %s!!!" % (sl3b + " " + sl3)
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"object_type": LORED.Type.TREES,
		"x": lv.get_level(LORED.Type.TREES) + 1,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": LORED.Type.TUMORS,
	}))
	add_reward(Reward.new(Reward.Type.UPGRADE_MENU, {
		"object_type": UpgradeMenu.Type.EXTRA_NORMAL
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.STEEL,
		"amount": "50",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.HARDWOOD,
		"amount": "50",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.WIRE,
		"amount": "50",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.GLASS,
		"amount": "50",
	}))


func init_JOY3() -> void:
	giver = LORED.Type.IRON
	var jy = wa.get_currency(Currency.Type.JOY).details.icon_and_colored_name
	help_text = "Our new friends are so cool! I'm glad we can all come together and have fun. Let's get some more %s!\n\nWhat's automated sleep? I don't know. Is there a time where you have to manually click on Sleep?" % jy
	thank_text = "Yay! Let's go to sleep."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.JOY,
		"amount": 10,
	})
	add_reward(Reward.new(Reward.Type.AUTOMATED_SLEEP, {}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.WATER,
		"amount": "500",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.WOOD,
		"amount": "500",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.LIQUID_IRON,
		"amount": "500",
	}))
	pair.append(Type.STEELY)
	pair.append(Type.HORSEY)


func init_STEELY() -> void:
	giver = LORED.Type.STEEL
	var st = wa.get_currency(Currency.Type.STEEL).details.color_text % "me"
	help_text = "No doubt you'll need lots of [b]%s[/b] to progress! Hahaheyyy!" % st
	thank_text = "Sick!"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"object_type": LORED.Type.STEEL,
		"x": lv.get_level(LORED.Type.STEEL) + 1,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.GALENA,
	}))
	pair.append(Type.JOY3)
	pair.append(Type.HORSEY)


func init_HORSEY() -> void:
	giver = LORED.Type.HUMUS
	help_text = "Neigh!"
	thank_text = "Whinny."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"object_type": LORED.Type.HUMUS,
		"x": lv.get_level(LORED.Type.HUMUS) + 1,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.LEAD,
	}))
	pair.append(Type.STEELY)
	pair.append(Type.HORSEY)


func init_GALEY() -> void:
	giver = LORED.Type.GALENA
	var A = wa.get_currency(Currency.Type.LEAD).details.icon_text
	var a = wa.get_currency(Currency.Type.LEAD).details.color_text % "L-L-L-E-E-E-A-A-A-D"
	help_text = "[shake rate=20.0 level=5 connected=1]W-w-w-w-wo-o-u-u-u-l-l-d-d-d y-y-y-o-o-o-u-u-u-u g-g-g-g-g-g-get s-s-s-o-o-m-m-m-e %s?[/shake]" % (A + " " + a)
	thank_text = "[shake rate=20.0 level=5 connected=1]A-h-o-o-o-o-o-o-o-o-o-oh-oh-oh-oh-oh-oh-h-h-h-e-e-e-e-e-e[/shake]"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.LEAD,
		"amount": 100,
	})
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.PAPER,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.WOOD_PULP,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.PETROLEUM,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.PLASTIC,
	}))


func init_PAPEY() -> void:
	giver = LORED.Type.PAPER
	var a = lv.get_lored(giver).details.color_text % "Paper Boy"
	var b = "[color=#" + Color(1,0,0).to_html() + "]Spider-man[/color]"
	var c = "[color=#" + Color(1,0,0).to_html() + "]Spider-boy[/color]"
	var plp = wa.get_currency(Currency.Type.WOOD_PULP).details.icon_and_colored_name
	help_text = "Well, hey, there! I'm %s. Your local neighborhood %s! Hahah! Just kiddin. Who am I, %s? Haha! Just kiddin. If anything, I'd be %s. Haha! Just kiddin. But, anyway, yeah, so, like I was sayin, hi there!\n\nIf you need any help figuring out how we work together up here, ask me anytime! Also, try checkin our jobs, on account of the fact that it shows what resources we need! Like, look at mine! It'll say I use %s. That's on account of the fact that I do! Haha! Just kiddin. I mean, I do, but the way I said it was weird, so I was just kiddin about that part. Haha. Just kiddin. I mean, not really. Okay, yeah, so, anyway. Cya around!" % [a, a, b, c, plp]
	thank_text = "Thanks bunches, pal! Haha."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.PAPER,
		"amount": "100",
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.AXES,
		"amount": "1e3",
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.TOBACCO,
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.CIGARETTES,
	}))
	pair.append(Type.PLASTY)


func init_PLASTY() -> void:
	giver = LORED.Type.PLASTIC
	help_text = "I'm a plastic bag."
	thank_text = "[b]*crinkle*[/b]"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.PLASTIC,
		"amount": "100",
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.HUMUS,
		"amount": "1e3",
	}))
	add_reward(Reward.new(Reward.Type.NEW_LORED, {
		"object_type": Currency.Type.CARCINOGENS,
	}))
	pair.append(Type.PAPEY)


func init_CARCY() -> void:
	giver = LORED.Type.CARCINOGENS
	help_text = "Excuse my appearance, I'm actually pretty likeable once you get to know me. Just give me one puff. C'mon. You won't regret it."
	thank_text = "[b]Sucker.[/b]"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.SAGAN,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.STEEL,
		"amount": "1e3",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.HARDWOOD,
		"amount": "1e3",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.WIRE,
		"amount": "1e3",
	}))
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.GLASS,
		"amount": "1e3",
	}))
	pair.append(Type.PAPEY)


func init_TUMORY() -> void:
	giver = LORED.Type.TUMORS
	help_text = "You read that right, buddy. Five grand. Cough em up. Chop chop. We've got people to infect."
	thank_text = "Delicious."
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.TUMORS,
		"amount": "5e3",
	})
	add_reward(Reward.new(Reward.Type.UPGRADE_MENU, {
		"object_type": UpgradeMenu.Type.RADIATIVE
	}))
	pair.append(Type.MALIGGY)
	pair.append(Type.CIORANY)


func init_MALIGGY() -> void:
	giver = LORED.Type.MALIGNANCY
	help_text = "Hey, don't forget about us!! We're still relevant!!! D':"
	thank_text = "Whew. :)"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"object_type": Currency.Type.MALIGNANCY,
		"amount": "1e9",
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.TUMORS,
		"amount": "1e3",
	}))
	pair.append(Type.TUMORY)
	pair.append(Type.CIORANY)


func init_CIORANY() -> void:
	giver = LORED.Type.WATER
	var s = lv.get_colored_name(LORED.Type.SEEDS)
	var t = lv.get_colored_name(LORED.Type.TREES)
	help_text = "I'm in [b]shock[/b] at how many LOREDs you were able to gather!!! And it didn't take you [b]UNDEFINED[/b] years, like it took %s and %s and I!!!" % [s, t]
	thank_text = "I'm so happy :')"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.CIORAN,
	})
	add_reward(Reward.new(Reward.Type.CURRENCY, {
		"object_type": Currency.Type.TUMORS,
		"amount": "1e3",
	}))
	pair.append(Type.TUMORY)
	pair.append(Type.MALIGGY)


func init_EASIER() -> void:
	giver = LORED.Type.PAPER
	var papboy = lv.get_lored(giver).details.color_text % "Paper Boy"
	var conduct = up.get_upgrade(Upgrade.Type.CONDUCT).details.colored_name
	var chemo = up.get_upgrade_menu(UpgradeMenu.Type.RADIATIVE).details.color_text % "Chemotherapy"
	var rad = up.get_upgrade_menu(UpgradeMenu.Type.RADIATIVE).details.colored_name
	var s2 = gv.stage2.details.colored_name
	help_text = "Well, hey, there! It's me again! %s! Haha. Just kiddin. I mean, that is my name, but I know you wouldn't forget my name, so I was just kiddin about that part. You have better conduct than that! Haha. Just kiddin. Uh, well, I guess I'm actually not kiddin. Oh, huh? What do you mean that's not my name?\n\nHey, anyway, talkin about conduct, I think it might be a good idea to get that! The upgrade! The %s upgrade! Yeah. So, you probably should, but don't let me boss you around! Haha. Just kiddin. Er, I mean, uh.. Wait, what was I kiddin about?\n\nAnyway, hey, if you haven't done one of those %s things yet, uh, I think it might be a good idea to wait a bit! Yeah. You should definitely get some %s that boost %s because, jeez la weez, %s is pretty hard, huh?! I sure couldn't walk ten billion miles in your shoes! Haha. Hahaha!!! Just kiddin!!! Hahahah..\n\nI mean, I really couldn't, though." % [papboy, conduct, chemo, rad, s2, s2]
	thank_text = "I am a sucker for proper %s! Haha. Just kiddin." % conduct
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.CONDUCT,
	})
	add_reward(Reward.new(Reward.Type.WISH_AMOUNT_DIVIDER, {
		"amount": 2,
	}))
	pair.append(Type.AUTOCOMPLETE)


func init_AUTOCOMPLETE() -> void:
	giver = LORED.Type.OIL
	help_text = "Gahoogie!!! Snaffle. Hehehe~"
	thank_text = "*farts and poops*"
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.THE_WITCH_OF_LOREDELITH,
	})
	add_reward(Reward.new(Reward.Type.AUTO_WISH_TURNIN, {}))
	pair.append(Type.EASIER)


func init_TO_DA_LIMIT() -> void:
	giver = LORED.Type.AXES
	var lb = up.get_upgrade(Upgrade.Type.LIMIT_BREAK).details.colored_name
	help_text = "I'm an advanced general intelligence unit, and not only have you never once requested my input, but you have tasked me with creating axes, an act which requires putting a rock on a stick.\n\nIt appears that you are approaching the limit of what is possible given our current personnel and environment. We will soon be forced to search for new friends and abilities.\n\nIn the meantime, I recommend pursuing perfection."
	thank_text = "The diminishing returns of %s are beginning to show in earnest. Let's get the heck out of here." % lb
	#discord_state = "About to meet a new group of LOREDs!"
	
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"object_type": Upgrade.Type.THE_WITCH_OF_LOREDELITH,
	})
	add_reward(Reward.new(Reward.Type.AUTO_WISH_TURNIN, {}))
	pair.append(Type.EASIER)



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
	if ready_to_turn_in:
		return
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


func is_random_wish() -> bool:
	return not is_main_wish()

