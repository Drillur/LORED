class_name UpgradeEffect
extends RefCounted



#region Sub-Classes

class UpgradeValue:
	
	var saved_vars := []
	
	var value: LoudFloat
	var applied_value: float
	var dynamic := false:
		set(val):
			if dynamic != val:
				dynamic = val
				if val:
					if not "value" in saved_vars:
						saved_vars.append("value")
				else:
					if "value" in saved_vars:
						saved_vars.erase("value")
	
	
	
	func _init(base_value: float):
		value = LoudFloat.new(base_value)
	
	
	
	func get_value() -> float:
		applied_value = value.get_value()
		return applied_value
	
	
	func get_applied_value() -> float:
		return applied_value


class UpgradeMethods:
	
	
	var applied_methods: Array[Callable]
	var removed_methods: Array[Callable]
	var value_reference: UpgradeValue:
		set(val):
			value_reference = val
			has_value_reference = true
	var has_value_reference := false
	
	
	
	func add_applied_method(method: Callable) -> void:
		if not method in applied_methods:
			applied_methods.append(method)
	
	
	func add_removed_method(method: Callable) -> void:
		if not method in removed_methods:
			removed_methods.append(method)
	
	
	func apply_methods() -> void:
		if has_value_reference:
			for method in applied_methods:
				method.call(value_reference.get_value())
		else:
			for method in applied_methods:
				method.call()
	
	
	func remove_methods() -> void:
		if has_value_reference:
			for method in applied_methods:
				method.call(value_reference.get_applied_value())
		else:
			for method in applied_methods:
				method.call()



class LOREDAttribute:
	extends UpgradeEffect
	
#region Sub-Classes (Haste, Output, Crit.Dynamic)
	
	
	class Haste:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends Haste
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attribute = LORED.Attribute.HASTE
			super(_lored_types, _value)
	
	
	
	class Output:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends Output
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attribute = LORED.Attribute.OUTPUT
			super(_lored_types, _value)
	
	
#endregion
	
	var attribute: LORED.Attribute
	var value: UpgradeValue
	var methods := UpgradeMethods.new()
	
	
	
	func _init(_lored_types: Array[LORED.Type], _value: float) -> void:
		super(Type.LORED_ATTRIBUTE)
		value = UpgradeValue.new(_value)
		methods.value = value
		match attribute:
			LORED.Attribute.HASTE:
				for lored in get_loreds(_lored_types):
					methods.add_applied_method(lored.haste.increase_multiplied)
					methods.add_removed_method(lored.haste.decrease_multiplied)
			LORED.Attribute.OUTPUT:
				for lored in get_loreds(_lored_types):
					methods.add_applied_method(lored.output.increase_multiplied)
					methods.add_removed_method(lored.output.decrease_multiplied)
		applied.became_true.connect(methods.apply_methods)
		applied.became_false.connect(methods.remove_methods)
		value.value.changed.connect(refresh)
	
	
	
	func get_loreds(_lored_types: Array[LORED.Type]) -> Array[LORED]:
		var loreds: Array[LORED]
		for lored_type in _lored_types:
			var lored = lv.get_lored(lored_type)
			loreds.append(lored)
		return loreds


#endregion



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

