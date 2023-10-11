class_name LOREDBuff
extends Buff



enum Type {
	WITCH,
}

# WITCH
var witch_output: Dictionary



func _init(_type: Type, _lored: LORED) -> void:
	type = _type
	key = Type.keys()[type]
	object = _lored
	
	ticked.connect(get(key + "_tick"))
	name = LOREDBuff.get_buff_name(type)
	
	match _type:
		Type.WITCH:
			set_ticks(-1)
			set_tick_rate(5 / object.haste.get_as_float())
			set_stack_limit(2)
			
			object.haste.changed.connect(WITCH_update_tick_rate)
			object.haste.changed.connect(WITCH_update_output)
			object.output.changed.connect(WITCH_update_output)
			stacks.changed.connect(WITCH_update_output)
			WITCH_update_output()
	
	super()



# - WITCH


func WITCH_tick() -> void:
	for cur in witch_output:
		var currency = wa.get_currency(cur) as Currency
		currency.add_from_lored(witch_output[cur])


func WITCH_update_tick_rate() -> void:
	tick_rate.set_to(5 / object.haste.get_as_float())


func WITCH_update_output() -> void:
	witch_output.clear()
	witch_output = object.get_produced_currency_rates()
	for cur in witch_output:
		witch_output[cur].m(5)



# - Get


static func get_buff_name(_type: Type) -> String:
	match _type:
		Type.WITCH:
			return "Aurus' Bounty"
	return "Oop?z"


static func get_description(_type: Type) -> String:
	match _type:
		Type.WITCH:
			return "Bestow upon a random LORED %s, granting them 5 seconds' worth of production every 5 seconds (increased by their Haste)." % get_buff_name(_type)
	return "O!ops"
