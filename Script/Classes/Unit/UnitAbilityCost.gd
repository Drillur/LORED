class_name UnitAbilityCost
extends Resource



var unit: Unit
var ability: UnitAbility
var resources: Dictionary # relevant resources stored here
var resource_cost := {}
var currency_cost := {}
var affordable := Bool.new(false)



func _init(_unit: Unit) -> void:
	unit = _unit
	unit.initialized.connect(unit_initialized)


func add_resource_cost(resource: UnitResource.Type, amount: float) -> void:
	if resource in resource_cost.keys():
		printerr(UnitResource.Type.keys()[resource], " already added as a resource_cost for UnitAbilityCost ", self, " (", ability.key, ")!")
		return
	resource_cost[resource] = Float.new(amount)
	memorize_unit_resource(resource)


func add_currency_cost(cur: Currency.Type, amount: float) -> void:
	if cur in currency_cost.keys():
		printerr("cur is already in currency_cost dict")
		return
	currency_cost[cur] = Float.new(amount)
	var currency = wa.get_currency(cur) as Currency
	currency.count.increased.connect(resource_increased)
	currency.count.decreased.connect(resource_decreased)


func memorize_unit_resource(resource_type: UnitResource.Type) -> void:
	resources[resource_type] = unit.resources[resource_type]
	resources[resource_type].value.current.increased.connect(resource_increased)
	resources[resource_type].value.current.decreased.connect(resource_decreased)


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
	for resource_type in resource_cost:
		var unit_resource: UnitResource = resources[resource_type]
		if unit_resource.get_value() < resource_cost[resource_type].get_value():
			affordable.set_to(false)
			return
	for cur in currency_cost:
		if wa.get_count(cur).less(get_cost(cur)):
			affordable.set_to(false)
			return
	affordable.set_to(true)



# - Action


func spend() -> void:
	for cur in currency_cost:
		wa.subtract(cur, currency_cost[cur].get_value())
	for resource in resource_cost:
		resources[resource].subtract(resource_cost[resource].get_value())



# - Get


func get_cost(cur: Currency.Type) -> float:
	return currency_cost[cur].get_value()
