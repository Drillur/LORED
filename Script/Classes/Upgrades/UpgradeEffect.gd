class_name UpgradeEffect
extends RefCounted



var saved_vars := [
	"applied",
]


func load_started() -> void:
	remove()


func load_finished() -> void:
	if applied:
		applied = false
		apply()


enum Type {
	HASTE,
	OUTPUT_AND_INPUT,
	OUTPUT_ONLY,
	SPECIFIC_INPUT,
	INPUT,
	CRIT,
	FUEL,
	FUEL_COST,
	BONUS_ACTION_ON_CURRENCY_GAIN,
	BONUS_ACTION_ON_CURRENCY_USE,
	BONUS_JOB_PRODUCTION,
	AUTOBUYER,
	UPGRADE_AUTOBUYER,
	UPGRADE_PERSIST,
	LORED_PERSIST,
	CURRENCY_PERSIST,
	FREE_LORED,
	UPGRADE_NAME,
	LIMIT_BREAK,
	APPLY_LORED_BUFF,
	
}

enum BONUS_ACTION {
	ADD_CURRENCY,
	INCREASE_EFFECT,
	INCREASE_EFFECT1_OR_2,
}

var type: int
var key: String
var text: String

var upgrade_type: int

var applied := false
var dynamic := false
var is_overwritten := Bool.new(false)

var effect: Value
var in_hand: Big

var effect2: Value
var in_hand2: Big

var apply_methods: Array
var remove_methods: Array
var affected_upgrades: Array

var effected_input: int
var effected_lored: int
var currency: int
var bonus_action_type: int
var modifier := 1.0
var added_currency: int
var upgrade_menu: int
var job: int
var buff: int

var affected_loreds := []

var replaced_upgrade_type := -1



func _init(_type: int, details: Dictionary) -> void:
	type = _type
	key = Type.keys()[type]
	upgrade_type = details["upgrade_type"]
	if "effect value" in details.keys():
		effect = Value.new(details["effect value"])
	if "effect value2" in details.keys():
		effect2 = Value.new(details["effect value2"])
	if "effected_input" in details.keys():
		effected_input = details["effected_input"]
	if "currency" in details.keys():
		currency = details["currency"]
	if "bonus_action_type" in details.keys():
		bonus_action_type = details["bonus_action_type"]
	if "modifier" in details.keys():
		modifier = details["modifier"]
	if "added_currency" in details.keys():
		added_currency = details["added_currency"]
	if "upgrade_menu" in details.keys():
		upgrade_menu = details["upgrade_menu"]
	if "affected_upgrades" in details.keys():
		affected_upgrades = details["affected_upgrades"]
	if "job" in details.keys():
		job = details["job"]
	if "effected_lored" in details.keys():
		effected_lored = details["effected_lored"]
	if "replaced_upgrade" in details.keys():
		replaced_upgrade_type = details["replaced_upgrade"]
	if "buff" in details.keys():
		buff = details["buff"]
	
	set_base_text()
	
	SaveManager.connect("load_started", load_started)
	SaveManager.connect("load_finished", load_finished)
	
	if (
		type in [
			Type.UPGRADE_AUTOBUYER,
			Type.UPGRADE_PERSIST,
		]
	):
		up.all_upgrades_initialized.connect(finish_init)
	
	if type == Type.CURRENCY_PERSIST:
		for cur in gv.get_currencies_in_stage(details["stage"]):
			var _currency = wa.get_currency(cur)
			apply_methods.append(_currency.persist.set_true)
			remove_methods.append(_currency.persist.reset)


func set_base_text() -> void:
	match type:
		Type.SPECIFIC_INPUT:
			text = wa.get_icon_and_name_text(effected_input) + " Input [b]x"
		Type.FUEL:
			text = "Max Fuel [b]x"
		Type.OUTPUT_AND_INPUT:
			text = "Output and Input [b]x"
		Type.OUTPUT_ONLY:
			text = "Output [b]x"
		Type.AUTOBUYER, Type.UPGRADE_AUTOBUYER:
			text = "Autobuyer"
		Type.CRIT:
			text = "Crit Chance [b]+"
		_:
			text = key.replace("_", " ").capitalize() + " [b]x"


func save_effect(val: bool) -> void:
	dynamic = val
	if val:
		saved_vars.append("effect")
		if effect2 != null:
			saved_vars.append("effect2")


func finish_init() -> void:
	match type:
		Type.UPGRADE_PERSIST:
			for _type in affected_upgrades:
				var upgrade = up.get_upgrade(_type)
				apply_methods.append(upgrade.enable_persist)
				remove_methods.append(upgrade.disable_persist)
		Type.UPGRADE_AUTOBUYER:
			for _type in up.get_upgrades_in_menu(upgrade_menu):
				var upgrade = up.get_upgrade(_type)
				apply_methods.append(upgrade.enable_autobuy)
				remove_methods.append(upgrade.disable_autobuy)
	


# - Signal

func currency_collected(amount: Big) -> void:
	var modded_amount = Big.new(amount).m(modifier).m(wa.get_currency(currency).last_crit_modifier)
	match bonus_action_type:
		BONUS_ACTION.ADD_CURRENCY:
			wa.add(added_currency, modded_amount)
		BONUS_ACTION.INCREASE_EFFECT:
			effect.add(modded_amount)
			effect.sync()
		BONUS_ACTION.INCREASE_EFFECT1_OR_2:
			if randi() % 2 == 0:
				effect.add(modded_amount)
				effect.sync()
			else:
				effect2.add(modded_amount)
				effect2.sync()


func currency_used(amount: Big) -> void:
	var modded_amount = Big.new(amount).m(modifier)
	match bonus_action_type:
		BONUS_ACTION.ADD_CURRENCY:
			wa.add(added_currency, modded_amount)
		BONUS_ACTION.INCREASE_EFFECT:
			effect.add(modded_amount)
		BONUS_ACTION.INCREASE_EFFECT1_OR_2:
			if randi() % 2 == 0:
				effect.add(modded_amount)
			else:
				effect2.add(modded_amount)


func reset_effects() -> void:
	var was_applied = applied
	if was_applied:
		remove()
	if effect != null:
		effect.reset()
	if effect2 != null:
		effect2.reset()
	if was_applied:
		apply()



# - Actions

func add_effected_lored(lored_type: int) -> void:
	var lored = lv.get_lored(lored_type) as LORED
	match type:
		Type.UPGRADE_NAME, Type.APPLY_LORED_BUFF:
			affected_loreds.append(lored_type)
		Type.LORED_PERSIST:
			apply_methods.append(lored.purchased.set_reset_value_true)
			remove_methods.append(lored.purchased.set_reset_value_false)
		Type.BONUS_JOB_PRODUCTION:
			var _job = lored.get_job(job) as Job
			apply_methods.append(_job.add_bonus_production)
			remove_methods.append(_job.remove_bonus_production)
		Type.FREE_LORED:
			apply_methods.append(lored.purchased.set_reset_value_true)
			remove_methods.append(lored.purchased.set_reset_value_false)
		Type.AUTOBUYER:
			apply_methods.append(lored.autobuy.set_true)
			remove_methods.append(lored.autobuy.set_false)
		Type.SPECIFIC_INPUT:
			for att in lored.get_attributes_by_currency(effected_input):
				apply_methods.append(att.increase_multiplied)
				remove_methods.append(att.decrease_multiplied)
		Type.HASTE:
			apply_methods.append(lored.haste.increase_multiplied)
			remove_methods.append(lored.haste.decrease_multiplied)
		Type.OUTPUT_AND_INPUT:
			apply_methods.append(lored.output.increase_multiplied)
			apply_methods.append(lored.input.increase_multiplied)
			remove_methods.append(lored.output.decrease_multiplied)
			remove_methods.append(lored.input.decrease_multiplied)
		Type.OUTPUT_ONLY:
			apply_methods.append(lored.output.increase_multiplied)
			remove_methods.append(lored.output.decrease_multiplied)
		Type.INPUT:
			apply_methods.append(lored.input.increase_multiplied)
			remove_methods.append(lored.input.decrease_multiplied)
		Type.CRIT:
			apply_methods.append(lored.crit.increase_added)
			remove_methods.append(lored.crit.decrease_added)
		Type.FUEL:
			apply_methods.append(lored.fuel.increase_multiplied)
			remove_methods.append(lored.fuel.decrease_multiplied)
		Type.FUEL_COST:
			apply_methods.append(lored.fuel_cost.increase_multiplied)
			remove_methods.append(lored.fuel_cost.decrease_multiplied)


func apply() -> void:
	if not applied:
		if effect != null:
			effect.changed.connect(refresh)
		if effect2 != null:
			effect2.changed.connect(refresh)
		
		if replaced_upgrade_type >= 0:
			var replaced_effect = up.get_upgrade(replaced_upgrade_type).effect as UpgradeEffect
			if replaced_effect.applied:
				replaced_effect.remove()
			replaced_effect.is_overwritten.set_to(true)
		
		match type:
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				var cur = wa.get_currency(currency) as Currency
				cur.increased_by_lored.connect(currency_collected)
			Type.BONUS_ACTION_ON_CURRENCY_USE:
				var cur = wa.get_currency(currency)
				cur.decreased_by_lored.connect(currency_used)
			Type.UPGRADE_NAME:
				for lored in lv.get_lored_in_list(affected_loreds):
					lored.output_increase.multiply(1.1)
					lored.input_increase.multiply(1.1)
					lored.fuel_cost.increase_multiplied(10)
					lored.fuel.increase_multiplied(10)
					lored.fuel.fill_up()
		
		apply_effects()


func remove() -> void:
	if applied:
		if effect != null:
			effect.changed.disconnect(refresh)
		if effect2 != null:
			effect2.changed.disconnect(refresh)
		
		if replaced_upgrade_type >= 0:
			var replaced_upgrade = up.get_upgrade(replaced_upgrade_type) as Upgrade
			replaced_upgrade.effect.is_overwritten.set_to(false)
			if replaced_upgrade.purchased.is_true():
				replaced_upgrade.effect.apply()
		
		match type:
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				var cur = wa.get_currency(currency)
				cur.increased_by_lored.disconnect(currency_collected)
			Type.BONUS_ACTION_ON_CURRENCY_USE:
				var cur = wa.get_currency(currency)
				cur.decreased_by_lored.disconnect(currency_used)
			Type.UPGRADE_NAME:
				for lored in lv.get_lored_in_list(affected_loreds):
					lored.output_increase.divide(1.1)
					lored.input_increase.divide(1.1)
					lored.fuel_cost.decrease_multiplied(10)
					lored.fuel.decrease_multiplied(10)
		
		remove_effects()


func refresh() -> void:
	match type:
		Type.BONUS_ACTION_ON_CURRENCY_GAIN:
			match upgrade_type:
				Upgrade.Type.ITS_SPREADIN_ON_ME:
					var iron := lv.get_lored(LORED.Type.IRON)
					var copper := lv.get_lored(LORED.Type.COPPER)
					var irono := lv.get_lored(LORED.Type.IRON_ORE)
					var copo := lv.get_lored(LORED.Type.COPPER_ORE)
					iron.output.alter_value(iron.output.multiplied, in_hand, effect.get_value())
					iron.input.alter_value(iron.input.multiplied, in_hand, effect.get_value())
					copper.output.alter_value(copper.output.multiplied, in_hand, effect.get_value())
					copper.input.alter_value(copper.input.multiplied, in_hand, effect.get_value())
					irono.output.alter_value(irono.output.multiplied, in_hand, effect.get_value())
					irono.input.alter_value(irono.input.multiplied, in_hand, effect.get_value())
					copo.output.alter_value(copo.output.multiplied, in_hand, effect.get_value())
					copo.input.alter_value(copo.input.multiplied, in_hand, effect.get_value())
				Upgrade.Type.ITS_GROWIN_ON_ME:
					var iron := lv.get_lored(LORED.Type.IRON)
					var copper := lv.get_lored(LORED.Type.COPPER)
					iron.output.alter_value(iron.output.multiplied, in_hand, effect.get_value())
					iron.input.alter_value(iron.input.multiplied, in_hand, effect.get_value())
					copper.output.alter_value(copper.output.multiplied, in_hand2, effect2.get_value())
					copper.input.alter_value(copper.input.multiplied, in_hand2, effect2.get_value())
					#print("Effect ", in_hand.text, " -> ", effect.get_text(), "\t\t Iron ", iron_output, " -> ", iron.output.get_text(), " - Copper ", copper_output, " -> ", copper.output.get_text())
		Type.BONUS_ACTION_ON_CURRENCY_USE:
			match upgrade_type:
				Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
					var coal := lv.get_lored(LORED.Type.COAL)
					coal.output.alter_value(coal.output.multiplied, in_hand, effect.get_value())
		_:
			remove_effects()
			apply_effects()
	
	in_hand.set_to(effect.get_value())
	if effect2 != null:
		in_hand2.set_to(effect2.get_value())


func apply_effects() -> void:
	if not applied and is_overwritten.is_false():
		applied = true
		
		if effect != null:
			in_hand = Big.new(effect.get_value())
		if effect2 != null:
			in_hand2 = Big.new(effect2.get_value())
		match type:
			Type.APPLY_LORED_BUFF:
				for lored_type in affected_loreds:
					var lored = lv.get_lored(lored_type)
					Buffs.apply_buff_on_lored(lored, buff)
			Type.LIMIT_BREAK:
				up.limit_break.enable()
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				match upgrade_type:
					Upgrade.Type.ITS_SPREADIN_ON_ME:
						var iron := lv.get_lored(LORED.Type.IRON)
						var copper := lv.get_lored(LORED.Type.COPPER)
						var irono := lv.get_lored(LORED.Type.IRON_ORE)
						var copo := lv.get_lored(LORED.Type.COPPER_ORE)
						iron.output.increase_multiplied(in_hand)
						iron.input.increase_multiplied(in_hand)
						copper.output.increase_multiplied(in_hand)
						copper.input.increase_multiplied(in_hand)
						irono.output.increase_multiplied(in_hand)
						irono.input.increase_multiplied(in_hand)
						copo.output.increase_multiplied(in_hand)
						copo.input.increase_multiplied(in_hand)
					Upgrade.Type.ITS_GROWIN_ON_ME:
						var iron := lv.get_lored(LORED.Type.IRON)
						var copper := lv.get_lored(LORED.Type.COPPER)
						iron.output.increase_multiplied(in_hand)
						iron.input.increase_multiplied(in_hand)
						copper.output.increase_multiplied(in_hand2)
						copper.input.increase_multiplied(in_hand2)
			Type.BONUS_ACTION_ON_CURRENCY_USE:
				match upgrade_type:
					Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
						var coal := lv.get_lored(LORED.Type.COAL)
						coal.output.increase_multiplied(in_hand)
			Type.BONUS_JOB_PRODUCTION:
				for method in apply_methods:
					method.call(currency, modifier)
			_:
				if effect == null:
					for method in apply_methods:
						method.call()
				else:
					for method in apply_methods:
						method.call(in_hand)


func remove_effects() -> void:
	if applied:
		applied = false
		
		match type:
			Type.APPLY_LORED_BUFF:
				for lored_type in affected_loreds:
					var lored = lv.get_lored(lored_type)
					Buffs.remove_buff_from_lored(lored, buff)
			Type.LIMIT_BREAK:
				up.limit_break.disable()
				up.limit_break.reset()
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				match upgrade_type:
					Upgrade.Type.ITS_SPREADIN_ON_ME:
						var iron := lv.get_lored(LORED.Type.IRON)
						var copper := lv.get_lored(LORED.Type.COPPER)
						var irono := lv.get_lored(LORED.Type.IRON_ORE)
						var copo := lv.get_lored(LORED.Type.COPPER_ORE)
						iron.output.decrease_multiplied(in_hand)
						iron.input.decrease_multiplied(in_hand)
						copper.output.decrease_multiplied(in_hand)
						copper.input.decrease_multiplied(in_hand)
						irono.output.decrease_multiplied(in_hand)
						irono.input.decrease_multiplied(in_hand)
						copo.output.decrease_multiplied(in_hand)
						copo.input.decrease_multiplied(in_hand)
					Upgrade.Type.ITS_GROWIN_ON_ME:
						var iron := lv.get_lored(LORED.Type.IRON)
						var copper := lv.get_lored(LORED.Type.COPPER)
						iron.output.decrease_multiplied(in_hand)
						iron.input.decrease_multiplied(in_hand)
						copper.output.decrease_multiplied(in_hand2)
						copper.input.decrease_multiplied(in_hand2)
			Type.BONUS_ACTION_ON_CURRENCY_USE:
				match upgrade_type:
					Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
						var coal := lv.get_lored(LORED.Type.COAL)
						coal.output.decrease_multiplied(in_hand)
			Type.BONUS_JOB_PRODUCTION:
				for method in remove_methods:
					method.call(currency)
			_:
				if effect == null:
					for method in remove_methods:
						method.call()
				else:
					for method in remove_methods:
						method.call(in_hand)



# - Get

func get_text() -> String:
	if effect == null:
		return text
	if type == Type.CRIT:
		return text + effect.get_text() + "%"
	return text + effect.get_text()


func get_effect_text() -> String:
	return effect.get_text()


func get_effect2_text() -> String:
	return effect2.get_text()


func get_dynamic_text() -> String:
	match upgrade_type:
		Upgrade.Type.ITS_SPREADIN_ON_ME:
			return "[center][b]x%s[/b] [i]for[/i] %s, %s, %s, and %s" % [
				effect.get_text(),
				lv.get_colored_name(LORED.Type.IRON_ORE),
				lv.get_colored_name(LORED.Type.COPPER_ORE),
				lv.get_colored_name(LORED.Type.IRON),
				lv.get_colored_name(LORED.Type.COPPER)
			]
		Upgrade.Type.ITS_GROWIN_ON_ME:
			return "[center][b]x%s[/b] [i]for[/i] %s\n[b]x%s[/b] [i]for[/i] %s" % [
				effect.get_text(),
				lv.get_colored_name(LORED.Type.IRON),
				effect2.get_text(),
				lv.get_colored_name(LORED.Type.COPPER)
			]
		Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
			return "[center][b]x%s[/b] [i]for[/i] %s" % [
				effect.get_text(),
				lv.get_colored_name(LORED.Type.COAL)
			]
	
	return "Freakin stinkin oops!"
