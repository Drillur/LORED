class_name HealingEvent
extends Reference



enum Type {
	RANDOM,
	TEST,
	BLOOD_LOSS,
}

var type: int

var key: String

var units := []
var unit_count: int

var starting_status_effects := {}




func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	
	var init_key = "init_" + key
	call(init_key)
	
	unit_count = len(units)


func init_TEST():
#	add_new_unit(Unit.Type.PET)
	#add_new_unit(Unit.Type.PET)
	#add_new_unit(Unit.Type.PET)
	add_starting_status_effect(0, UnitStatusEffect.Type.OPEN_WOUND)
	add_starting_status_effect(1, UnitStatusEffect.Type.UNCOMMON_COLD)
	add_starting_status_effect(2, UnitStatusEffect.Type.DISEASED)
	add_new_unit(Unit.Type.HEAVY_CIVILIAN)
	add_new_unit(Unit.Type.AVERAGE_CIVILIAN)
	add_new_unit(Unit.Type.HEAVY_CIVILIAN)
	set_starting_health(0)
	#set_starting_blood(0, 0.4)
	set_starting_health(1)
	set_starting_health(2)


func init_BLOOD_LOSS():
	add_new_unit(Unit.Type.SKINNY_CIVILIAN)
	set_starting_health(0)
	set_starting_blood(0)
	




func add_starting_status_effect(unit_index: int, _type: int) -> void:
	if not unit_index in starting_status_effects.keys():
		starting_status_effects[unit_index] = []
	starting_status_effects[unit_index].append(_type)


func add_new_unit(_type: int) -> void:
	units.append(Unit.new(_type))


func set_starting_health(unit_index: int, value := 0.4) -> void:
	units[unit_index].health.set_to_percent(value)


func set_starting_blood(unit_index: int, value := 0.4) -> void:
	units[unit_index].blood.set_to_percent(value)



func get_units() -> Array:
	return units
