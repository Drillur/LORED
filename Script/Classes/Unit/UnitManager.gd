class_name UnitManager
extends Node



var unit: Unit

var recovering_resources := []



func setup(_unit: Unit) -> void:
	unit = _unit
	for resource in unit.resources:
		var unit_resource: UnitResource = unit.resources[resource]
		if unit_resource.recovers_over_time():
			recovering_resources.append(unit_resource)
			unit_resource.value.current.decreased.connect(unit_resource_decreased)
			unit_resource.value.filled.connect(unit_resource_decreased)




# - Signals


func _process(delta):
	for resource in recovering_resources:
		resource = resource as UnitResource
		if resource.value.is_not_full():
			resource.value.add(resource.recovery_rate.get_value() * delta)


func unit_resource_decreased() -> void:
	set_process(true)


func unit_resource_filled() -> void:
	for resource in recovering_resources:
		if resource.is_not_full():
			return
	set_process(false)
