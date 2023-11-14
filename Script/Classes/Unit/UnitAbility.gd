class_name UnitAbility
extends Resource


enum Type {
	MEND,
	
	CURE,
	REGENERATE,
	CLEANSE,
	HEAL,
	REJUVENATE,
	SHIELD,
	
	# GARDEN/WITCH
	PICK_FLOWER,
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
			details.description = "Pick {output} {currency:RANDOM_FLOWER}."
			details.icon = res.get_resource("001")
			cost_text = "Costs {stamina_cost}."
			output = Float.new(1)
			cooldown = Cooldown.new(8)
			cost.add_cost(UnitResource.Type.STAMINA, 2)
		Type.MEND:
			school = School.HIEROMANCY
			details.description = "Restores {initial_heal} to a single target. Gets the job done."
			details.icon = res.get_resource("082")
			cost_text = "Costs {mana_cost}."
			cast_time = Float.new(3)
			initial_heal = Float.new(1)


func unit_initialized() -> void:
	if cost.cost == {}:
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
	if has_cooldown() and cooldown.is_active():
		return false
	return true


func get_description() -> String:
	var text := details.description
	if "{output}" in text:
		text = text.format({"output": Big.get_float_text(output.get_value())})
	if "{currency" in text:
		var cur_key: String = text.split("{currency:")[1].split("}")[0]
		var currency: Currency = wa.get_currency(Currency.Type[cur_key])
		if output:
			text = text.format({
				"currency:" + cur_key: currency.details.get_icon_and_colored_name(output.get_value())
			})
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
		var unit_resource: UnitResource = unit.unit_resources[type] as UnitResource
		var resource_text = unit_resource.details.icon_and_colored_name
		var cost_text = cost.cost[type].get_text()
		text = text.format({"stamina_cost": cost_text + " " + resource_text})
	if "{flower_cost}" in text:
		var currency = Flowers.get_currency(cost.flower_cost) as Currency
		text = text.format({
			"flower_cost":
				"1 " + currency.details.icon_and_colored_name
		})
	return text


func has_cooldown() -> bool:
	return cooldown != null


func has_cost() -> bool:
	return cost != null
