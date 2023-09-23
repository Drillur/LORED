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
	SPECIFIC_INPUT,
	SPECIFIC_COST,
	COST,
	INPUT,
	CRIT,
	FUEL,
	FUEL_COST,
	ERASE_CURRENCY_FROM_COST,
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
var is_overwritten := false

var effect: Value
var in_hand: Big

var effect2: Value
var in_hand2: Big

var xp: ValuePair

var apply_methods: Array
var remove_methods: Array
var effected_upgrades: Array

var effected_input: int
var effected_lored: int
var currency: int
var bonus_action_type: int
var modifier := 1.0
var added_currency: int
var upgrade_menu: int
var job: int

var affected_loreds := []

var replaced_upgrade := -1



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
	if "effected_upgrades" in details.keys():
		effected_upgrades = details["effected_upgrades"]
	if "job" in details.keys():
		job = details["job"]
	if "effected_lored" in details.keys():
		effected_lored = details["effected_lored"]
	if "replaced_upgrade" in details.keys():
		replaced_upgrade = details["replaced_upgrade"]
	if "xp" in details.keys():
		xp = details["xp"]
		xp.do_not_cap_current()
		xp.total.set_to(get_limit_break_total_xp())
	
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
		Type.COST:
			text = "Cost [b]x"
		Type.SPECIFIC_INPUT:
			text = wa.get_icon_and_name_text(effected_input) + " Input [b]x"
		Type.SPECIFIC_COST:
			text = wa.get_currency_name(effected_input) + " Cost [b]x"
		Type.FUEL:
			text = "Max Fuel [b]x"
		Type.OUTPUT_AND_INPUT:
			text = "Output and Input [b]x"
		Type.AUTOBUYER, Type.UPGRADE_AUTOBUYER:
			text = "Autobuyer"
		Type.CRIT:
			text = "Crit Chance [b]+"
		_:
			text = key.replace("_", " ").capitalize() + " [b]x"


func set_dynamic(val: bool) -> void:
	dynamic = val
	if val:
		saved_vars.append("effect")
		if effect2 != null:
			saved_vars.append("effect2")
		if xp != null:
			saved_vars.append("xp")


func finish_init() -> void:
	match type:
		Type.UPGRADE_PERSIST:
			for _type in effected_upgrades:
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



func increase_limit_break_xp(amount: Big) -> void:
	xp.add(amount)
	#var prev_mod = Big.new(effect.get_value())
	while xp.is_full():
		level_up_limit_break()


func level_up_limit_break(level: Big = Big.new(effect.get_value).a(1)) -> void:
	effect.set_to(level)
	xp.subtract(xp.get_total())
	xp.total.set_to(get_limit_break_total_xp())


func get_limit_break_total_xp() -> Big:
	var level = effect.get_as_int() + 1
	var exponent = sqrt(level) * 1.5
	exponent = round(max(exponent, 3.0))
	return Big.new("1e" + str(exponent))



# - Actions

func add_effected_lored(lored_type: int) -> void:
	var lored = lv.get_lored(lored_type) as LORED
	match type:
		Type.LORED_PERSIST:
			apply_methods.append(lored.purchased.set_reset_value_true)
			remove_methods.append(lored.purchased.set_reset_value_false)
		Type.LIMIT_BREAK:
			apply_methods.append(lored.connect_limit_break)
			remove_methods.append(lored.disconnect_limit_break)
		Type.BONUS_JOB_PRODUCTION:
			var _job = lored.get_job(job) as Job
			apply_methods.append(_job.add_bonus_production)
			remove_methods.append(_job.remove_bonus_production)
		Type.COST:
			for cur in lored.cost.cost:
				apply_methods.append(
					lored.cost.cost[cur].increase_multiplied
				)
				remove_methods.append(
					lored.cost.cost[cur].decrease_multiplied
				)
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
		Type.SPECIFIC_COST:
			apply_methods.append(
				lored.cost.cost[effected_input].increase_multiplied
			)
			remove_methods.append(
				lored.cost.cost[effected_input].decrease_multiplied
			)
		Type.HASTE:
			apply_methods.append(lored.haste.increase_multiplied)
			remove_methods.append(lored.haste.decrease_multiplied)
		Type.OUTPUT_AND_INPUT:
			apply_methods.append(lored.output.increase_multiplied)
			apply_methods.append(lored.input.increase_multiplied)
			remove_methods.append(lored.output.decrease_multiplied)
			remove_methods.append(lored.input.decrease_multiplied)
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
		Type.UPGRADE_NAME:
			affected_loreds.append(lored_type)


func apply() -> void:
	if not applied:
		if type != Type.LIMIT_BREAK:
			if effect != null:
				effect.increased.connect(refresh)
			if effect2 != null:
				effect2.increased.connect(refresh)
		
		if replaced_upgrade >= 0:
			var r_up = up.get_upgrade(replaced_upgrade)
			var was_applied = r_up.effect.applied
			if was_applied:
				r_up.effect.remove()
			r_up.is_overwritten = true
			if was_applied:
				r_up.effect.apply()
		
		match type:
			Type.ERASE_CURRENCY_FROM_COST:
				var lored = lv.get_lored(effected_lored)
				var cost = lored.cost as Cost
				cost.erase_currency_from_cost(currency)
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				var cur = wa.get_currency(currency)
				cur.increased_by_lored.connect(currency_collected)
			Type.BONUS_ACTION_ON_CURRENCY_USE:
				var cur = wa.get_currency(currency)
				cur.decreased_by_lored.connect(currency_used)
			Type.UPGRADE_NAME:
				for lored in lv.get_lored_in_list(affected_loreds):
					lored.cost_increase.increase_multiplied(0.9)
					lored.fuel_cost.increase_multiplied(10)
					lored.fuel.increase_multiplied(10)
					lored.fuel.fill_up()
		
		refresh()


func remove() -> void:
	if applied:
		if type != Type.LIMIT_BREAK:
			if effect != null:
				effect.increased.disconnect(refresh)
			if effect2 != null:
				effect2.increased.disconnect(refresh)
		
		if replaced_upgrade >= 0:
			var r_up = up.get_upgrade(replaced_upgrade)
			var was_applied = r_up.effect.applied
			if was_applied:
				r_up.effect.remove()
			r_up.is_overwritten = false
			if was_applied:
				r_up.effect.apply()
		
		match type:
			Type.ERASE_CURRENCY_FROM_COST:
				var lored = lv.get_lored(effected_lored)
				var cost = lored.cost as Cost
				cost.add_currency_to_cost(currency)
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				var cur = wa.get_currency(currency)
				cur.increased_by_lored.disconnect(currency_collected)
			Type.BONUS_ACTION_ON_CURRENCY_USE:
				var cur = wa.get_currency(currency)
				cur.decreased_by_lored.disconnect(currency_used)
			Type.UPGRADE_NAME:
				for lored in lv.get_lored_in_list(affected_loreds):
					lored.cost_increase.decrease_multiplied(0.9)
					lored.fuel_cost.decrease_multiplied(10)
					lored.fuel.decrease_multiplied(10)
		
		remove_effects()


func refresh() -> void:
	remove_effects()
	apply_effects()


func apply_effects() -> void:
	if not applied:
		applied = true
		if is_overwritten:
			return
		
		if effect != null:
			in_hand = Big.new(effect.get_value())
		if effect2 != null:
			in_hand2 = Big.new(effect2.get_value())
		match type:
			Type.LIMIT_BREAK:
				apply_methods[0].get_object().currency_produced.connect(increase_limit_break_xp)
				apply_methods[0].get_object().apply_limit_break.call(effect)
				apply_methods[0].call(effect.increased)
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
			Type.AUTOBUYER, Type.UPGRADE_AUTOBUYER, Type.FREE_LORED:
				for method in apply_methods:
					method.call()
			_:
				for method in apply_methods:
					method.call(in_hand)


func remove_effects() -> void:
	if applied:
		applied = false
		if is_overwritten:
			return
		
		match type:
			Type.LIMIT_BREAK:
				remove_methods[0].get_object().currency_produced.disconnect(increase_limit_break_xp)
				remove_methods[0].get_object().remove_limit_break.call(effect)
				remove_methods[0].call(effect.increased)
			Type.BONUS_ACTION_ON_CURRENCY_GAIN:
				match upgrade_type:
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
			Type.AUTOBUYER, Type.FREE_LORED:
				for method in remove_methods:
					method.call()
			_:
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
