class_name LOREDBuff
extends Buff



enum Type {
	WITCH,
}

# WITCH
var witch_output: Big
var witch_added_rate := false



func _init(_type: Type, _lored: LORED) -> void:
	type = _type
	key = Type.keys()[type]
	object = _lored
	
	ticked.connect(get(key + "_tick"))
	details.name = LOREDBuff.get_buff_name(type)
	
	match _type:
		Type.WITCH:
			var currency = wa.get_currency(_lored.primary_currency)
			details.color = currency.details.color
			details.description = "+5 seconds' worth of %s" % currency.details.icon_and_colored_name
			set_ticks(-1)
			set_tick_rate(5 / object.haste.get_as_float())
			affected_by_bonus_ticks = true
			bonus_ticks = Int.new(5)
			set_stack_limit(2)
			
			object.haste.changed.connect(WITCH_update_output)
			object.output.changed.connect(WITCH_update_output)
			object.haste.changed.connect(WITCH_update_tick_rate)
			stacks.changed.connect(WITCH_update_output)
			WITCH_update_output()
	
	super()



# - WITCH


func WITCH_tick() -> void:
	var currency = wa.get_currency(object.primary_currency) as Currency
	currency.add_from_lored(witch_output)


func WITCH_update_tick_rate() -> void:
	if witch_added_rate:
		wa.get_currency(object.primary_currency).subtract_gain_rate(Big.new(witch_output).d(tick_rate.get_value()))
	
	tick_rate.set_to(5 / object.haste.get_as_float())
	
	wa.get_currency(object.primary_currency).add_gain_rate(Big.new(witch_output).d(tick_rate.get_value()))
	witch_added_rate = true


func WITCH_update_output() -> void:
	if witch_added_rate:
		wa.get_currency(object.primary_currency).subtract_gain_rate(Big.new(witch_output).d(tick_rate.get_value()))
	
	witch_output = object.get_primary_rate()
	witch_output.m(5).powerInt(stacks.get_value())
	
	wa.get_currency(object.primary_currency).add_gain_rate(Big.new(witch_output).d(tick_rate.get_value()))
	witch_added_rate = true




# - Get


static func get_buff_name(_type: Type) -> String:
	match _type:
		Type.WITCH:
			return "Aurus' Bounty"
	return "Oop?z"


static func get_description(_type: Type) -> String:
	match _type:
		Type.WITCH:
			return "Bestow upon a random LORED %s, granting them 5 seconds' worth of their primary currency production every 5 seconds (reduced by their Haste)." % LOREDBuff.get_buff_name(_type)
	return "O!ops"
