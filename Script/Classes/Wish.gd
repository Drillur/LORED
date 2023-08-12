class_name Wish
extends Resource



class Reward:
	enum Type {
		CURRENCY,
		NEW_LORED,
		JUST_TEXT,
		UPGRADE_MENU,
		INCREASED_RANDOM_WISH_LIMIT,
	}
	
	var TYPE_KEYS := Type.keys()
	
	signal completed
	
	var type: int
	var key: String
	var text: String
	
	var amount: Big
	var currency: Currency
	var lored: LORED
	var unlocked_feature: String
	var upgrade_menu_type: int
	
	
	func _init(_type: int, data: Dictionary) -> void:
		type = _type
		key = TYPE_KEYS[type]
		
		call("init_" + key, data)
	
	
	func init_CURRENCY(data: Dictionary) -> void:
		currency = wa.get_currency(data["currency"]) as Currency
		if data["amount"] is Big:
			amount = data["amount"]
		else:
			amount = Big.new(data["amount"])
		text = (currency.color_text % "+%s ") + currency.icon_and_name_text
	
	
	func init_NEW_LORED(data: Dictionary) -> void:
		lored = lv.get_lored(data["lored"]) as LORED
		text = "New LORED - " + lored.icon_and_name_text
	
	
	func init_INCREASED_RANDOM_WISH_LIMIT(data: Dictionary) -> void:
		amount = Big.new(data["amount"])
		text = "+" + amount.toString() + " Random Wish Limit"
	
	
	func init_UPGRADE_MENU(data: Dictionary) -> void:
		upgrade_menu_type = data["menu"]
		var upgrade_menu: UpgradeMenu = up.get_upgrade_menu(upgrade_menu_type)
		text = upgrade_menu.icon_and_name_text() + " Upgrade Menu"
	
	
	func init_JUST_TEXT(data: Dictionary) -> void:
		text = data["text"]
	
	
	
	func receive() -> void:
		if has_method("receive_" + key):
			call("receive_" + key)
	
	
	func receive_CURRENCY() -> void:
		currency.add(amount)
	
	
	func receive_NEW_LORED() -> void:
		lv.unlock_lored(lored.type)
	
	
	func receive_INCREASED_RANDOM_WISH_LIMIT() -> void:
		wi.random_wish_limit += 1
	
	
	func receive_UPGRADE_MENU() -> void:
		up.unlock_menu(upgrade_menu_type)
	
	
	
	func has_text() -> bool:
		return text != ""
	
	
	func get_text() -> String:
		if not has_method("get_text_" + key):
			return text
		return call("get_text_" + key)
	
	
	func get_text_CURRENCY() -> String:
		return text % amount.toString()



class Objective:
	
	enum Type {
		LORED_LEVELED_UP,
		UPGRADE_PURCHASED,
		ACCEPTABLE_FUEL,
		COLLECT_CURRENCY,
		SLEEP,
	}
	
	var TYPE_KEYS := Type.keys()
	
	signal completed
	
	var type: int
	var key: String
	var icon: Texture
	var color: Color
	var text: String
	
	var progress: Attribute
	
	var currency: Currency
	var lored: LORED
	var lored_was_already_asleep: bool
	var upgrade: Upgrade
	
	
	
	func _init(_type: int, data: Dictionary) -> void:
		type = _type
		key = TYPE_KEYS[type]
		
		call("init_" + key, data)
		
		progress.change_base(0)
		progress.set_to(0)
	
	
	func init_LORED_LEVELED_UP(data: Dictionary) -> void:
		progress = Attribute.new(1)
		lored = lv.get_lored(data["lored"]) as LORED
		icon = lored.icon
		color = lored.color
		text = "Level Up"
	
	
	func init_ACCEPTABLE_FUEL(data: Dictionary) -> void:
		progress = Attribute.new(75)
		lored = lv.get_lored(data["lored"]) as LORED
		icon = lored.icon
		color = lored.color
		text = lored.name + " 75% Fuel"
	
	
	func init_COLLECT_CURRENCY(data: Dictionary) -> void:
		progress = Attribute.new(data["amount"])
		currency = wa.get_currency(data["currency"]) as Currency
		icon = currency.icon
		color = currency.color
		text = "Collect " + currency.name
	
	
	func init_SLEEP(data: Dictionary) -> void:
		progress = Attribute.new(data["amount"])
		lored = lv.get_lored(data["lored"]) as LORED
		lored_was_already_asleep = lored.asleep
		icon = lored.icon
		color = lored.color
		text = "Sleep"
	
	
	func init_UPGRADE_PURCHASED(data: Dictionary) -> void:
		progress = Attribute.new(1)
		upgrade = up.get_upgrade(data["upgrade"]) as Upgrade
		icon = upgrade.icon
		color = upgrade.color
		text = upgrade.name + " Purchased"
	
	
	
	# - Actions
	
	func start() -> void:
		if has_method("already_completed_" + key):
			if call("already_completed_" + key):
				progress.set_to_percent(1)
				emit_signal("completed")
				return
		call("start_" + key)
		await progress.filled
		emit_signal("completed")
	
	
	func start_LORED_LEVELED_UP() -> void:
		await lored.leveled_up
		progress.add(1)
	
	
	func already_completed_ACCEPTABLE_FUEL() -> bool:
		return lored.fuel.get_current_percent() >= 0.75
	func start_ACCEPTABLE_FUEL() -> void:
		lored.fuel.add_notify_change_method(update_ACCEPTABLE_FUEL)
		await completed
		lored.fuel.remove_notify_method(update_ACCEPTABLE_FUEL)
	func update_ACCEPTABLE_FUEL() -> void:
		progress.set_to(lored.fuel.get_current_percent() * 100)
	
	
	func start_COLLECT_CURRENCY() -> void:
		currency.connect("increased", update_COLLECT_CURRENCY)
		await completed
		currency.disconnect("increased", update_COLLECT_CURRENCY)
	func update_COLLECT_CURRENCY(amount_increased: Big) -> void:
		progress.add(amount_increased)
	
	
	func start_SLEEP() -> void:
		while progress.is_not_full():
			await lored.second_passed_while_asleep
			progress.add(1)
		wake_up_sleeping_lored()
	
	func wake_up_sleeping_lored() -> void:
		if type == Type.SLEEP and not lored_was_already_asleep:
			lored.wake_up()
	
	
	func already_completed_UPGRADE_PURCHASED() -> bool:
		return upgrade.purchased
	func start_UPGRADE_PURCHASED() -> void:
		await upgrade.just_purchased
		progress.set_to(1)
	
	
	
	# - Flash Shit
	
	func will_flash_something() -> bool:
		return has_method("flash_" + key)
	
	
	func flash() -> void:
		call("flash_" + key)
	
	
	func flash_LORED_LEVELED_UP() -> void:
		gv.flash(lored.vico.level_up, lored.color)
	
	
	func flash_ACCEPTABLE_FUEL() -> void:
		gv.flash(lored.vico.fuel_bar, lored.color)
	
	
	func flash_SLEEP() -> void:
		gv.flash(lored.vico.sleep, lored.color)




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

var TYPE_KEYS := Type.keys()

signal became_ready_to_turn_in
signal just_turned_in
signal just_dismissed
signal just_ended
signal became_ready_to_start

var type: int
var pair := []
var key: String

var vico:
	set(val):
		vico = val
		has_vico = true
var has_vico := false

var turned_in := false
var ready_to_start := false
var ready_to_turn_in := false
var skip_wish := false

var help_text: String
var thank_text: String

var giver: LORED

var rewards := []

var objective: Objective




func _init(_type: int) -> void:
	type = _type
	key = TYPE_KEYS[type]
	
	call("init_" + key)
	objective.connect("completed", objective_completed)
	
	if not has_method("await_" + key):
		ready_to_start = true
		emit_signal("became_ready_to_start")
	else:
		call("await_" + key)
		await became_ready_to_start
		ready_to_start = true
	
	if not skip_wish:
		start()



func await_STUFF() -> void:
	await gv.get_tree().create_timer(5).timeout
	if lv.get_lored(LORED.Type.COAL).purchased:
		skip_wish = true
		wi.completed_wishes.append(type)
	emit_signal("became_ready_to_start")


func idk(x: float) -> float:
	if x > 50:
		return 1.0
	return (50 - (50 * (1 - exp(-x/5)))) / 10 + 1


func init_RANDOM() -> void:
	giver = lv.get_random_active_lored() as LORED
	var obj_key = giver.get_wish()
	var obj_type = Objective.Type[obj_key]
	var data := {}
	#var experience_modifier = idk(wi.completed_random_wishes)
	var rewards_modifier := randf_range(10, 30)
	match obj_key:
		"COLLECT_CURRENCY":
			var amount: Big
			var currency: Currency = giver.wished_currency
			if currency.produced_by.size() == 0:
				amount = Big.new(randi_range(2, 5))
			else:
				amount = Big.new(currency.gain_rate.get_total())
				var amount_modifier = randf_range(20, 40)
				amount.m(amount_modifier)
				#amount.d(experience_modifier)
			data = {
				"currency": currency.type,
				"amount": amount.roundDown(),
			}
		"LORED_LEVELED_UP":
			data = {"lored": giver.type}
		"SLEEP":
			data = {
				"lored": giver.type,
				"amount": round(randi_range(6, 20)),# / experience_modifier),
			}
		"ACCEPTABLE_FUEL":
			data = {"lored": giver.type}
		"UPGRADE_PURCHASED":
			data = {"upgrade": giver.wished_upgrade.type}
	objective = Objective.new(obj_type, data)
	
	
	var reward_count = 1
	var teehee = 50
	while randi() % 100 < teehee:
		reward_count += 1
		teehee *= 0.66
	rewards_modifier /= reward_count
	rewards_modifier *= 1 + randf()
	#rewards_modifier /= experience_modifier
	
	var cur_keys := {}
	for i in reward_count:
		var amount: Big
		var currency: Currency = wa.get_weighted_random_currency()
		amount = Big.new(currency.gain_rate.get_total()).m(rewards_modifier).roundDown()
		amount.capMin(1)
		if currency.type in cur_keys:
			rewards[cur_keys[currency.type]].amount.a(amount)
		else:
			cur_keys[currency.type] = i
			rewards.append(Reward.new(Reward.Type.CURRENCY, {
				"currency": currency.type,
				"amount": amount,
			}))



func init_STUFF() -> void:
	giver = lv.get_lored(LORED.Type.STONE)
	help_text = "I want to pick up rocks, but I'm out of [b]fuel!![/b] Help!"
	var img_text = "[img=<15>]" + gv.TEXTURES["Level"].get_path() + "[/img]"
	help_text += "\n\nClick on Coal's " + img_text + " Level Up button to make him become active!"
	thank_text = "That's the stuff. Thanks!"
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"lored": LORED.Type.COAL,
	})


func init_FUEL() -> void:
	giver = lv.get_lored(LORED.Type.COAL)
	help_text = "If Stone wants my stuff, I'm happy to share!"
	thank_text = "Glad I could help. :)"
	objective = Objective.new(Objective.Type.ACCEPTABLE_FUEL, {
		"lored": LORED.Type.STONE,
	})
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.STONE,
		"amount": 15,
	}))


func init_COLLECTION() -> void:
	giver = lv.get_lored(LORED.Type.STONE)
	help_text = "I'm just going to pick up some of these."
	thank_text = "Rocks are neat."
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"currency": Currency.Type.STONE,
		"amount": 10,
	})
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.IRON_ORE,
	}))
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.COPPER_ORE,
	}))
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.IRON,
	}))
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.COPPER,
	}))


func init_IMPORTANCE_OF_COAL() -> void:
	giver = lv.get_lored(LORED.Type.COAL)
	help_text = "Yikes!! Everyone is taking my stuff! No rest for the righteous, I guess!"
	thank_text = "Whew."
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"currency": Currency.Type.COAL,
		"amount": 25,
	})
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.COAL,
		"amount": 50,
	}))
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.IRON,
		"amount": 10,
	}))
	pair.append(Type.UPGRADE_STONE)


func init_UPGRADE_STONE() -> void:
	giver = lv.get_lored(LORED.Type.IRON)
	help_text = "Stone seems like he's got a little much to do. Could you level him up to make it easier on him?"
	thank_text = "Awesome! I bet he's liking that. Thanks :)"
	objective = Objective.new(Objective.Type.LORED_LEVELED_UP, {
		"lored": LORED.Type.STONE,
	})
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.STONE,
		"amount": 50,
	}))
	rewards.append(Reward.new(Reward.Type.JUST_TEXT, {
		"text": "LOREDs can sleep!"
	}))
	pair.append(Type.IMPORTANCE_OF_COAL)


func init_TEST_SLEEP() -> void:
	giver = lv.get_lored(LORED.Type.COPPER)
	help_text = "I'm about to introduce you to [b]Upgrades[/b], but first, uh... I'm tired. I want to take a nap."
	thank_text = "Whuh? Whozzat? Where am I?"
	objective = Objective.new(Objective.Type.SLEEP, {
		"lored": LORED.Type.COPPER,
		"amount": 15,
	})
	rewards.append(Reward.new(Reward.Type.UPGRADE_MENU, {
		"menu": UpgradeMenu.Type.NORMAL
	}))
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.COPPER,
		"amount": 15,
	}))


func init_GRINDER() -> void:
	giver = lv.get_lored(LORED.Type.STONE)
	help_text = "Whoa?! Does the GRINDER upgrade work on rocks?"
	thank_text = "This is awesome!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"upgrade": Upgrade.Type.GRINDER,
	})
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.IRON,
		"amount": 30,
	}))
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.COPPER,
		"amount": 30,
	}))
	rewards.append(Reward.new(Reward.Type.INCREASED_RANDOM_WISH_LIMIT, {
		"amount": 1,
	}))


func init_JOY() -> void:
	giver = lv.get_lored(LORED.Type.IRON)
	help_text = "Hey, it looks like everyone is opening up to you! They're sharing their Wishes! Isn't that nice?"
	thank_text = "Whoa, look! Growth just showed up!"
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"currency": Currency.Type.JOY,
		"amount": 3,
	})
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.GROWTH,
	}))


func init_JOBS() -> void:
	giver = lv.get_lored(LORED.Type.STONE)
	help_text = "I noticed that when Growth appeared, you got even more confused that before! I mean, how is any of this working?! Who is taking resources from who? What are each of us capable of?! When will my rock bag get full??!"
	thank_text = "Don't mention it. You're welcome!"
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"currency": Currency.Type.GRIEF,
		"amount": 3,
	})
	rewards.append(Reward.new(Reward.Type.JUST_TEXT, {
		"text": "You can view LOREDs' Jobs and their details!"
	}))


func init_RYE() -> void:
	giver = lv.get_lored(LORED.Type.GROWTH)
	help_text = "[b][i]I AM CURRENTLY IN AN [u]UNFORTUNATE[/u] SITUATION."
	thank_text = "[b][i]IT WOULD APPEAR THAT THERE WILL BE [u]NO END[/u] TO MY SUFFERING."
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"upgrade": Upgrade.Type.RYE,
	})
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.JOULES,
	}))
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.CONCRETE,
	}))


func init_SAND() -> void:
	giver = lv.get_lored(LORED.Type.JOULES)
	help_text = "If you really want to progress, you could get this Upgrade over here."
	thank_text = "Yeah, uhh... good job."
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"upgrade": Upgrade.Type.SAND,
	})
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.OIL,
	}))
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.TARBALLS,
	}))
	rewards.append(Reward.new(Reward.Type.NEW_LORED, {
		"lored": LORED.Type.MALIGNANCY,
	}))


func init_MALIGNANCY() -> void:
	giver = lv.get_lored(LORED.Type.MALIGNANCY)
	help_text = "Heyo! It's grinding time, baby! You'll want this much Malignancy before you " + (up.get_menu_color_text(UpgradeMenu.Type.MALIGNANT) % "Metastaize") + ".\n\nWhat's that, you ask? Teheheheeeee >:D"
	thank_text = "Good luck. Have fun!"
	objective = Objective.new(Objective.Type.COLLECT_CURRENCY, {
		"currency": Currency.Type.MALIGNANCY,
		"amount": "3e3",
	})
	rewards.append(Reward.new(Reward.Type.UPGRADE_MENU, {
		"menu": UpgradeMenu.Type.MALIGNANT
	}))


func init_SOCCER_DUDE() -> void:
	giver = lv.get_lored(LORED.Type.COPPER_ORE)
	help_text = "You've got to reset to get this one, boss, see? But, you don't have to reset right now, boss. Do what you want. You're the boss, boss, see, boss?"
	thank_text = "Wicked, boss, real wicked. We're rolling with the big cats, now, boss!"
	objective = Objective.new(Objective.Type.UPGRADE_PURCHASED, {
		"upgrade": Upgrade.Type.SOCCER_DUDE,
	})
	rewards.append(Reward.new(Reward.Type.CURRENCY, {
		"currency": Currency.Type.MALIGNANCY,
		"amount": "1e3",
	}))





# - Actions

func start() -> void:
	objective.start()



func objective_completed() -> void:
	ready_to_turn_in = true
	emit_signal("became_ready_to_turn_in")



func turn_in() -> void:
	for rew in rewards:
		rew.receive()
	wa.add(Currency.Type.JOY, 1)
	turned_in = true
	emit_signal("just_turned_in")
	emit_signal("just_ended")


func dismiss() -> void:
	objective.wake_up_sleeping_lored()
	wa.add(Currency.Type.GRIEF, 1)
	emit_signal("just_dismissed")
	emit_signal("just_ended")



func flash_something() -> void:
	if objective.will_flash_something():
		objective.flash()
	else:
		gv.flash(vico)



# - Get

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
			data[rew.currency.type] = rew.amount
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
	return rewards.size() > 0


func is_main_wish() -> bool:
	return type > 0


