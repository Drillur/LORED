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
}

enum School {
	NATURE,
	HIEROMANCY,
	ANTHOMANCY,
	HEMOMANCY,
}

signal just_cast
signal currency_gained(cur, amount)

var type: Type
var school: School

var key: String

var details := Details.new()

var unit: Unit

var cost: UnitAbilityCost
var cast_time: Float
var initial_heal: Float
var initial_barrier: Float
var cooldown: Cooldown
var output: Float
var output_range: FloatPair

var applied_buffs := []

var dispells_buffs := false
var dispells_debuffs := false

var cost_text: String



func _init(_type: Type, _unit: Unit) -> void:
	unit = _unit
	unit.initialized.connect(unit_initialized)
	type = _type
	key = Type.keys()[type]
	details.name = key.replace("_", " ").capitalize()
	cost = UnitAbilityCost.new(unit)
	match type:
		Type.PICK_FLOWER:
			school = School.NATURE
			var a = wa.get_icon_and_name_text(Currency.Type.RANDOM_FLOWER)
			details.description = "Pick {output} %s." % a
			details.icon = res.get_resource("001")
			cost_text = "Costs {resource_cost}."
			output = Float.new(1)
			cooldown = Cooldown.new(8)
			cost.add_resource_cost(UnitResource.Type.STAMINA, 2)
		Type.SIFT_SEEDS:
			school = School.NATURE
			var a = wa.get_icon_and_name_text(Currency.Type.SEEDS)
			var b = wa.get_currency(Currency.Type.RANDOM_FLOWER).details.icon_and_plural_name_text
			details.description = "Sift through available %s in search of {output_range} %s." % [a, b]
			details.icon = res.get_resource("seed")
			cost_text = "Costs {currency_cost}."
			output_range = FloatPair.new(0, 2)
			cast_time = Float.new(2)
			cost.add_resource_cost(UnitResource.Type.STAMINA, 2)
			cost.add_currency_cost(Currency.Type.SEEDS, 10)
		Type.MEND:
			school = School.HIEROMANCY
			details.description = "Restores {initial_heal} to a single target. Gets the job done."
			details.icon = res.get_resource("082")
			cost_text = "Costs {resource_cost} and {currency_cost}."
			cast_time = Float.new(3)
			initial_heal = Float.new(1)
			#cost.add_currency_cost(Currency.Type., 2)


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
			currency_gained.emit(flower, output.get_value())
	just_cast.emit()



# - Get


func can_cast() -> bool:
	if has_cost() and not cost.affordable.is_true():
		return false
	return has_no_cooldown() or cooldown.is_nearly_or_already_inactive()


func get_description() -> String:
	var text := details.description
	if "{output}" in text:
		text = text.format({"output": output.get_text()})
	if "{output_range}" in text:
		text = text.format({"output_range": output_range.get_text_with_hyphon()})
#	if "{applied_buffs}" in text:
#		var applied_buff_text := ""
#		for x in applied_buffs:
#			x = x as UnitStatusEffect
#			applied_buff_text += "\n[i]" + x.name + "[/i] - " + x.get_inactive_description()
#		text = text.format({"applied_buffs": applied_buff_text})
	if "{initial_heal}" in text:
		text = text.format({"initial_heal": gv.wrap_text_by_type(initial_heal.get_total_text(), "health")})
#	if "{barrier}" in text:
#		text = text.format({"barrier": gv.wrap_text_by_type(barrier.get_total_text(), "barrier")})
	return text


func get_cost_text() -> String:
	var text := cost_text
#	if "{mana_cost}" in text:
#		text = text.format({"mana_cost": gv.wrap_text_by_type(mana_cost.get_total_text(), "mana")})
	if "{stamina_cost}" in text:
		var type = UnitResource.Type.STAMINA
		var unit_resource: UnitResource = unit.resources[type] as UnitResource
		var resource_text = unit_resource.details.icon_and_colored_name
		var cost_text = cost.cost[type].get_text()
		text = text.format({"stamina_cost": cost_text + " " + resource_text})
	if "{currency_cost}" in text:
		var currency = wa.get_currency(cost.currency_cost.keys()[0]) as Currency
		text = text.format({
			"currency_cost":
				"1 " + currency.details.icon_and_colored_name
		})
	if "{resource_cost}" in text:
		var type = cost.resource_cost.keys()[0] as Currency
		var unit_resource: UnitResource = unit.resources[type] as UnitResource
		var resource_text = unit_resource.details.icon_and_colored_name
		var cost_text = cost.cost[type].get_text()
		text = text.format({"resource_cost": cost_text + " " + resource_text})
	return text


func has_cooldown() -> bool:
	return cooldown != null


func has_no_cooldown() -> bool:
	return cooldown == null


func has_cost() -> bool:
	return cost != null
