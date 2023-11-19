class_name UnitBuff
extends Buff



enum Type {
	CORE_RIFT,
}

#var ability_type: UnitAbility.Type

var output: Float



func _init(_type: Type, unit: Unit) -> void:
	type = _type
	key = Type.keys()[type]
	object = unit
	
	ticked.connect(get(key + "_tick"))
	details.name = UnitBuff.get_buff_name(type)
	
	match _type:
		Type.CORE_RIFT:
			var ability_type = UnitAbility.Type.CORE_RIFT
			output = Float.new(unit.get_ability(ability_type).output.get_value())
			details.color = unit.get_ability(ability_type).details.color
			var a = wa.get_currency(Currency.Type.MANA).details.icon_and_name_text
			details.description = "Recovering {output} %s each second." % a
			set_ticks(8)
			set_tick_rate(1.0)
			set_stack_limit(1)
	
	super()



func CORE_RIFT_tick() -> void:
	object.add_mana(output.get_value())



# - Get


func get_description() -> String:
	var text := details.description
	if "{output}" in text:
		text = text.format({"output": output.get_text()})
	return text


static func get_buff_name(_type: Type) -> String:
	match _type:
		_:
			return Type.keys()[_type].capitalize().replace("_", " ")
