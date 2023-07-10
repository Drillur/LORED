class_name HealingEvent
extends Reference



enum Type {
	RANDOM,
	TEST,
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
	add_new_unit(Unit.Type.PET)
	#add_new_unit(Unit.Type.PET)
	#add_new_unit(Unit.Type.PET)
	add_new_unit(Unit.Type.SKINNY_CIVILIAN)
	add_new_unit(Unit.Type.AVERAGE_CIVILIAN)
#	add_new_unit(Unit.Type.HEAVY_CIVILIAN)
	units[0].set_current_health(rand_range(1,15))
	units[1].set_current_health(rand_range(1,15))
	units[2].set_current_health(rand_range(20,30))
	starting_status_effects[2].append(UnitStatusEffect.Type.COMMON_COLD)



func add_new_unit(_type: int) -> void:
	units.append(Unit.new(_type))
	starting_status_effects[units.size() - 1] = []



func get_units() -> Array:
	return units
