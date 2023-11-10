class_name LOREDBuff
extends Buff



enum Type {
	WITCH,
}



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
			set_tick_rate(WITCH_get_tick_rate())
			affected_by_bonus_ticks = true
			bonus_ticks = Int.new(5)
			set_stack_limit(2)
			
			gv.about_to_prestige.connect(WITCH_subtract_rate)
			object.haste.changed.connect(WITCH_update_output)
			object.output.changed.connect(WITCH_update_output)
			object.haste.changed.connect(WITCH_update_tick_rate)
			stacks.changed.connect(WITCH_update_output)
			up.get_upgrade(Upgrade.Type.GRIMOIRE).purchased.changed.connect(WITCH_update_output)
			gv.prestiged.connect(WITCH_add_rate)
			
			witch_output = WITCH_get_output()
	
	super()



# - WITCH


var witch_output: Big
var witch_added_rate := false


func WITCH_tick() -> void:
	var currency = wa.get_currency(object.primary_currency) as Currency
	currency.add_from_buff(witch_output)


func WITCH_update_tick_rate() -> void:
	WITCH_subtract_rate()
	tick_rate.set_to(WITCH_get_tick_rate())
	WITCH_add_rate()


func WITCH_get_tick_rate() -> float:
	return 1 + (4 / object.haste.get_as_float())


func WITCH_update_output() -> void:
	WITCH_subtract_rate()
	witch_output = WITCH_get_output()
	WITCH_add_rate()


func WITCH_get_output() -> Big:
	var base = object.get_primary_rate()
	if up.is_upgrade_purchased(Upgrade.Type.GRIMOIRE):
		base.m(max(1, gv.stage1.times_reset))
	return base.m(5).powerInt(stacks.get_value())


func WITCH_add_rate() -> void:
	return
#	if not witch_added_rate:
#		wa.get_currency(object.primary_currency).add_gain_rate(
#			Big.new(witch_output).d(tick_rate.get_value())
#		)
#		witch_added_rate = true


func WITCH_subtract_rate() -> void:
	return
#	if witch_added_rate:
#		wa.get_currency(object.primary_currency).subtract_gain_rate(
#			Big.new(witch_output).d(tick_rate.get_value())
#		)
#		witch_added_rate = false



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
