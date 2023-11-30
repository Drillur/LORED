class_name UpgradeEffect
extends RefCounted



class UpgradeValue:
	
	var saved_vars := []
	
	var value: LoudFloat
	var applied_value: float
	var dynamic: bool
	
	
	
	func _init(base_value: float, _dynamic: bool):
		value = LoudFloat.new(base_value)
		dynamic = _dynamic
		if dynamic:
			saved_vars.append("value")
	
	
	
	func get_value() -> float:
		applied_value = value.get_value()
		return applied_value
	
	
	func get_applied_value() -> float:
		return applied_value


class LOREDAttributeUpgradeEffect:
	
	extends MethodsUpgradeEffect
	
	
	
	var saved_vars := []
	
	var loreds: Array[LORED]
	var attributes: Array[LORED.Attribute]
	
	
	
	func _init(
		_loreds: Array[LORED.Type],
		_attributes: Array[LORED.Attribute],
		_base_value: float,
		_dynamic: bool
	):
		super(UpgradeEffect.Type.LORED_ATTRIBUTE)
		for type in _loreds:
			loreds.append(lv.get_lored(type))
		attributes = _attributes
		value = UpgradeValue.new(_base_value, _dynamic)
		if _dynamic: 
			saved_vars.append("value")
		for lored in loreds:
			for attribute in attributes:
				match attribute:
					LORED.Attribute.HASTE:
						applied_methods.append(lored.haste.increase_multiplied)
						removed_methods.append(lored.haste.decrease_multiplied)
					LORED.Attribute.OUTPUT:
						applied_methods.append(lored.output.increase_multiplied)
						removed_methods.append(lored.output.decrease_multiplied)
					LORED.Attribute.INPUT:
						applied_methods.append(lored.input.increase_multiplied)
						removed_methods.append(lored.input.decrease_multiplied)
					LORED.Attribute.FUEL:
						applied_methods.append(lored.fuel.increase_multiplied)
						removed_methods.append(lored.fuel.decrease_multiplied)
					LORED.Attribute.FUEL_COST:
						applied_methods.append(lored.fuel_cost.increase_multiplied)
						removed_methods.append(lored.fuel_cost.decrease_multiplied)
					LORED.Attribute.CRIT:
						applied_methods.append(lored.crit.increase_added)
						removed_methods.append(lored.crit.decrease_added)


class MethodsUpgradeEffect:
	
	extends UpgradeEffect
	
	
	
	var applied_methods := []
	var removed_methods := []
	var value: UpgradeValue
	var has_value := false
	
	
	
	func _init(_type: Type):
		super(_type)
		applied.became_true.connect(apply_methods)
		applied.became_false.connect(remove_methods)
	
	
	func apply_methods() -> void:
		if has_value:
			for method in applied_methods:
				method.call(value.get_value())
		else:
			for method in applied_methods:
				method.call()
	
	
	func remove_methods() -> void:
		if has_value:
			for method in removed_methods:
				method.call(value.get_applied_value())
		else:
			for method in removed_methods:
				method.call()

enum Type {
	LORED_ATTRIBUTE,
}

var type: Type:
	set(val):
		type = val
		key = Type.keys()[type]
var key: String
var applied := LoudBool.new(false)



func _init(_type: Type) -> void:
	type = _type



func apply():
	if applied.is_true():
		return
	applied.set_to(true)


func remove():
	if applied.is_false():
		return
	applied.set_to(false)


func refresh():
	if applied.is_true():
		remove()
		apply()




# - Get

