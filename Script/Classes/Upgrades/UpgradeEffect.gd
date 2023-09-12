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
}

var type: int
var key: String
var text: String

var applied := false

var effect: Value
var in_hand: Big



func _init(_type: int, details: Dictionary) -> void:
	type = _type
	key = Type.keys()[type]
	set_base_text()
	
	SaveManager.connect("load_started", load_started)
	SaveManager.connect("load_finished", load_finished)


func set_base_text() -> void:
	match type:
		_:
			text = key.replace("_", " ").capitalize() + " [b]x"


func save_effect() -> void:
	saved_vars.append("effect")



# - Signal




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
			apply_methods.append(lored.enable_purchased_on_reset)
			remove_methods.append(lored.disable_purchased_on_reset)
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
				for x in gv.get_loreds_in_stage(1):
					var lored = lv.get_lored(x)
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
				for x in gv.get_loreds_in_stage(1):
					var lored = lv.get_lored(x)
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
