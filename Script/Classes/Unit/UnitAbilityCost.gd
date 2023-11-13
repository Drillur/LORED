class_name UnitAbilityCost
extends Resource



var unit: Unit
var unit_ability: UnitAbility
var unit_resources: Dictionary # relevant resources stored here
var cost := {}
var flower_cost: Flowers.Type
var affordable := Bool.new(false)



func _init(_unit: Unit) -> void:
	unit = _unit
	unit.initialized.connect(unit_initialized)


func add_cost(resource: UnitResource.Type, amount: float) -> void:
	if resource in cost.keys():
		printerr(UnitResource.Type.keys()[resource], " already added as a cost for UnitAbilityCost ", self, " (", unit_ability.key, ")!")
		return
	cost[resource] = Float.new(amount)
	memorize_unit_resource(resource)


func add_flower_cost(flower_type: Flowers.Type) -> void:
	flower_cost = flower_type
	var currency = wa.get_currency(int(flower_type)) as Currency
	currency.count.increased.connect(resource_increased)
	currency.count.decreased.connect(resource_decreased)


func memorize_unit_resource(resource_type: UnitResource.Type) -> void:
	unit_resources[resource_type] = unit.unit_resources[resource_type]
	unit_resources[resource_type].increased.connect(resource_increased)
	unit_resources[resource_type].decreased.connect(resource_decreased)


func unit_initialized() -> void:
	check_if_affordable()



# - Internal


func resource_increased() -> void:
	if affordable.is_false():
		check_if_affordable()


func resource_decreased() -> void:
	if affordable.is_true():
		check_if_affordable()


func check_if_affordable() -> void:
	for resource_type in cost:
		var unit_resource: UnitResource = unit_resources[resource_type]
		if unit_resource.get_value() < cost[resource_type].get_value():
			affordable.set_to(false)
			return
	if flower_cost > 0 and wa.get_count(flower_cost).less(1):
		affordable.set_to(false)
	affordable.set_to(true)


