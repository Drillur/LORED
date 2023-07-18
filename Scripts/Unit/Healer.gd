class_name Healer
extends Node



var mana := Attribute.new(20)
var blood := Attribute.new(300)

var mana_regen := Attribute.new(2, false)
var healer_pass: int

var crit_multiplier := Attribute.new(2, false)

var abilities := {}



func open():
	healer_pass = OS.get_ticks_msec()
	init_abilities()
	regenerate_mana_loop()


func close() -> void:
	healer_pass = OS.get_ticks_msec()



func init_abilities():
	add_ability(UnitAbility.Type.MEND)
	add_ability(UnitAbility.Type.CURE)
	add_ability(UnitAbility.Type.REGENERATE)
	add_ability(UnitAbility.Type.CLEANSE)
	add_ability(UnitAbility.Type.SHIELD)
	add_ability(UnitAbility.Type.HEAL)
	add_ability(UnitAbility.Type.REJUVENATE)



func add_ability(type: int) -> void:
	if type in abilities.keys():
		return
	abilities[type] = UnitAbility.new(type)



func regenerate_mana_loop():
	var t = Timer.new()
	add_child(t)
	var my_pass = healer_pass
	while not is_queued_for_deletion():
		if my_pass != healer_pass:
			break
		t.start(3)
		yield(t, "timeout")
		if mana.get_current().less(mana.get_total()):
			mana.add(mana_regen.get_total())
	
	t.queue_free()



# - Get

func is_targeting_something() -> bool:
	return lv.lored[lv.Type.BLOOD].vico.healing_event.targeting_something


func get_target() -> Unit:
	return lv.lored[lv.Type.BLOOD].vico.healing_event.target_vico.unit


func get_crit_chance() -> float:
	return lv.lored[lv.Type.BLOOD].crit


func get_crit_multiplier() -> float:
	return crit_multiplier.get_as_float()



# - Actions

func heal(target: Unit, amount) -> void:
	amount = multiply_by_crit(amount)
	target.take_healing(amount)




# - Handy

func multiply_by_crit(amount) -> Big:
	if not amount is Big:
		amount = Big.new(amount)
	var roll = rand_range(0, 100)
	if roll < get_crit_chance():
		return amount.m(get_crit_multiplier())
	return amount








