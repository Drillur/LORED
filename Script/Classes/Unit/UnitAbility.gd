class_name UnitAbility
extends Resource


enum Type {
	NONE,
	
	MEND,
	
	CURE,
	REGENERATE,
	CLEANSE,
	HEAL,
	REJUVENATE,
	SHIELD,
	
	# GARDEN/WITCH
	PICK_FLOWER,
	SIFT_SEEDS,
	PLANT_SEED,
	
	# ARCANE
	ARCANE_FOCUS,
	CORE_RIFT,
	SUPPLEMANCE,
}

enum School {
	NONE,
	HIEROMANCY,
	ANTHOMANCY,
	HEMOMANCY,
	ARCANIMANCY,
}

signal currency_gained(cur, amount)

var type: Type
var school: School

var key: String

var details := Details.new()

var unit: Unit
var target: Unit

var cost: UnitAbilityCost
var cast_time: Float
var cooldown: Cooldown
var output: Float
var output_range: FloatPair
var channeled_output: Float

var applied_buffs := []

var dispells_buffs := false
var dispells_debuffs := false
var channeled := false

var cost_text: String



func _init(_type: Type, _unit: Unit) -> void:
	unit = _unit
	unit.initialized.connect(unit_initialized)
	type = _type
	key = Type.keys()[type]
	details.name = key.replace("_", " ").capitalize()
	cost = UnitAbilityCost.new(unit)
	match type:
		# - Garden
		Type.PICK_FLOWER:
			school = School.NONE
			var a = wa.get_icon_and_name_text(Currency.Type.RANDOM_FLOWER)
			details.description = "Pick {output} %s." % a
			details.icon = res.get_resource("001")
			cost_text = "Costs {resource_cost}."
			output = Float.new(1)
			cooldown = Cooldown.new(8)
			cost.add_resource_cost(UnitResource.Type.STAMINA, 2)
		Type.SIFT_SEEDS:
			school = School.NONE
			var a = wa.get_icon_and_name_text(Currency.Type.SEEDS)
			var b = wa.get_currency(Currency.Type.FLOWER_SEED).details.icon_and_plural_name_text
			details.description = "Sift through available %s in search of {output_range} %s." % [a, b]
			details.icon = res.get_resource("seed")
			cost_text = "Costs {currency_cost}."
			output_range = FloatPair.new(0, 2)
			cast_time = Float.new(2)
			cost.add_resource_cost(UnitResource.Type.STAMINA, 2)
			cost.add_currency_cost(Currency.Type.SEEDS, 10)
		Type.PLANT_SEED:
			school = School.NONE
			var a = wa.get_currency(Currency.Type.FLOWER_SEED).details.icon_and_plural_name_text
			details.description = "Plant {output} %s." % a
			details.icon = res.get_resource("seed")
			cost_text = "Costs {currency_cost}."
			output = Float.new(1)
			cost.add_currency_cost(Currency.Type.FLOWER_SEED, 1)
		
		
		# - Arcane
		
		Type.ARCANE_FOCUS:
			school = School.ARCANIMANCY
			var a = wa.get_currency(Currency.Type.MANA).details.icon_and_name_text
			var z = wa.get_currency(Currency.Type.MANA).details.color_text % "{channeled_output}"
			details.description = "Restores %s %s per second. Channeled." % [z, a]
			details.icon = res.get_resource("Mana")
			details.color = wa.get_color(Currency.Type.MANA)
			cast_time = Float.new(10)
			channeled_output = Float.new(0.1)
			channeled = true
		Type.CORE_RIFT:
			school = School.ARCANIMANCY
			details.icon = res.get_resource("liq")
			details.color = wa.get_color(Currency.Type.MANA)
			var a = wa.get_currency(Currency.Type.MANA).details.color_text % UnitBuff.get_buff_name(UnitBuff.Type.CORE_RIFT)
			var b = wa.get_currency(Currency.Type.MANA).details.icon_and_name_text
			details.description = "Gain %s for 8 seconds, which restores {output} %s per second." % [a, b]
			cost_text = "Costs {resource_cost}."
			output = Float.new(1)
			applied_buffs.append(UnitBuff.Type.CORE_RIFT)
			cost.add_resource_cost(UnitResource.Type.MANA, 1)
		Type.SUPPLEMANCE:
			school = School.ARCANIMANCY
			var a = wa.get_currency(Currency.Type.MANA).details.color_text % "{output}"
			var b = wa.get_currency(Currency.Type.MANA).details.icon_and_name_text
			var c = wa.get_currency(Currency.Type.MANA).details.color_text % UnitBuff.get_buff_name(UnitBuff.Type.CORE_RIFT)
			details.description = "Restores %s %s. Renews %s if it is active." % [a, b, c]
			details.icon = res.get_resource("Mana")
			details.color = wa.get_color(Currency.Type.MANA)
			cost_text = "Costs {resource_cost}."
			cast_time = Float.new(1.5)
			output = Float.new(5)
			cost.add_resource_cost(UnitResource.Type.MANA, 1)
			cooldown = Cooldown.new(6)


func unit_initialized() -> void:
	if cost.resource_cost == {} and cost.currency_cost == {}:
		cost = null



# - Action


func cast() -> void:
	if has_cost():
		cost.spend()
	if has_cooldown():
		cooldown.activate()
	match type:
		Type.PICK_FLOWER:
			var flower: Currency.Type = Flowers.get_random_flower()
			Flowers.add_random_flower(false, output.get_value())
			wa.add_from_player(flower, output.get_value())
			currency_gained.emit(flower, output.get_value())
		Type.SIFT_SEEDS:
			var gained_flower_seeds = randi_range(
				int(output_range.current.get_value()), int(output_range.total.get_value())
			)
			if gained_flower_seeds > 0:
				wa.add_from_player(Currency.Type.FLOWER_SEED, gained_flower_seeds)
			currency_gained.emit(Currency.Type.FLOWER_SEED, gained_flower_seeds)
		Type.SUPPLEMANCE:
			unit.add_mana(output.get_value())
			if unit.has_buff(UnitBuff.Type.CORE_RIFT):
				Buffs.get_buff(unit, UnitBuff.Type.CORE_RIFT).refresh()
	for buff_type in applied_buffs:
		Buffs.apply_buff_on_unit(unit, buff_type) # replace unit with target later



# - Get


func can_cast() -> bool:
	if has_cost() and cost.affordable.is_false():
		print("not affordable")
		return false
	return has_no_cooldown() or cooldown.is_nearly_or_already_inactive()


func get_description() -> String:
	var text := details.description
	if "{output}" in text:
		text = text.format({"output": output.get_text()})
	if "{output_range}" in text:
		text = text.format({"output_range": output_range.get_text_with_hyphon()})
	if "{channeled_output}" in text:
		text = text.format({"channeled_output": channeled_output.get_text()})
#	if "{barrier}" in text:
#		text = text.format({"barrier": gv.wrap_text_by_type(barrier.get_total_text(), "barrier")})
	return text


func get_cost_text() -> String:
	var text := cost_text
	if "{currency_cost}" in text:
		var currency = wa.get_currency(cost.currency_cost.keys()[0]) as Currency
		var cost_amount_float = cost.currency_cost.values()[0]
		#var amount = cost_amount_float.get_value()
		var amount_text = cost_amount_float.get_text()
		
		var actual_amount_text = currency.count.get_text()
		text = text.format({
			"currency_cost":
				"%s/%s %s" % [amount_text, actual_amount_text, currency.details.icon_and_name_text]
		})
	if "{resource_cost}" in text:
		var _type = cost.resource_cost.keys()[0]
		var unit_resource: UnitResource = unit.resources[_type] as UnitResource
		var resource_text = unit_resource.details.icon_and_colored_name
		var _cost_text = cost.resource_cost[_type].get_text()
		text = text.format({"resource_cost": "%s %s" % [_cost_text, resource_text]})
	return text


func get_cast_time() -> float:
	return cast_time.get_value()


func has_cooldown() -> bool:
	return cooldown != null


func has_no_cooldown() -> bool:
	return cooldown == null


func has_cost() -> bool:
	return cost != null


func has_cast_time() -> bool:
	return cast_time != null
