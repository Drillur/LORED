class_name UpgradeEffect
extends Resource



#region Sub-Classes


class LOREDList:
	extends RefCounted
	
	var loreds: Array[LORED]
	var lored_text: String
	
	func _init(_lored_types: Array[LORED.Type]) -> void:
		loreds = lv.get_loreds_in_list(_lored_types)
	
	
	func get_highest_lored_type() -> int:
		var i := 0
		var highest_type := 0
		for lored in loreds:
			if lored.type > highest_type:
				highest_type = int(lored.type)
			i += 1 
		return highest_type


class UpgradeValue:
	extends RefCounted
	
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
	
	
	func reset() -> void:
		value.reset()
	
	
	func get_value() -> float:
		applied_value = value.get_value()
		return applied_value
	
	
	func get_applied_value() -> float:
		return applied_value


class UpgradeMethods:
	extends UpgradeEffect
	
	
	#region Sub-Classes
	class WithValue:
		extends UpgradeMethods
		
		
		
		var value: UpgradeValue
		
		
		
		func apply_methods() -> void:
			for method in applied_methods:
				method.call(value.get_value())
		
		
		func remove_methods() -> void:
			for method in removed_methods:
				method.call(value.get_applied_value())
	
	
	class WithoutValue:
		extends UpgradeMethods
		
		
		
		func apply_methods() -> void:
			for method in applied_methods:
				method.call()
		
		
		func remove_methods() -> void:
			for method in removed_methods:
				method.call()
	#endregion
	
	
	var applied_methods: Array[Callable]
	var removed_methods: Array[Callable]
	
	
	
	func add_applied_method(method: Callable) -> void:
		if not method in applied_methods:
			applied_methods.append(method)
	
	
	func add_removed_method(method: Callable) -> void:
		if not method in removed_methods:
			removed_methods.append(method)



class LOREDAttribute:
	extends UpgradeMethods.WithValue
	
	#region Sub-Classes (Haste, Output, Crit.Dynamic)
	
	class Haste:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends Haste
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.HASTE]
			super(_lored_types, _value)
	
	
	class Output:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends Output
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.OUTPUT]
			super(_lored_types, _value)
	
	
	class OutputAndInput:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends OutputAndInput
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.OUTPUT, LORED.Attribute.INPUT]
			super(_lored_types, _value)
	
	
	class _Input:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends _Input
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.INPUT]
			super(_lored_types, _value)
	
	
	class Fuel:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends Fuel
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.FUEL]
			super(_lored_types, _value)
	
	
	class FuelCost:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends FuelCost
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.FUEL_COST]
			super(_lored_types, _value)
	
	
	class Crit:
		extends LOREDAttribute
		
		
		class Dynamic:
			extends Crit
			
			func _init(_lored_types: Array[LORED.Type], _value: float):
				super(_lored_types, _value)
				value.dynamic = true
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.CRIT]
			super(_lored_types, _value)
	
	#endregion
	
	var attributes: Array[LORED.Attribute]
	var lored_list: LOREDList
	
	func _init(_lored_types: Array[LORED.Type], _value: float) -> void:
		super(Type.LORED_ATTRIBUTE)
		value = UpgradeValue.new(_value)
		value.value.changed.connect(refresh)
		value.value.changed.connect(update_text)
		value.value.changed.connect(emit_changed)
		applied.became_true.connect(apply_methods)
		applied.became_false.connect(remove_methods)
		applied.became_false.connect(value.value.reset)
		set_lored_recipients_text(_lored_types)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		has_value = true
		match attributes:
			[LORED.Attribute.HASTE]:
				text = LoudString.new("Haste [b]x%s")
				for lored in lored_list.loreds:
					add_applied_method(lored.haste.increase_multiplied)
					add_removed_method(lored.haste.decrease_multiplied)
			[LORED.Attribute.OUTPUT]:
				text = LoudString.new("Output [b]x%s")
				for lored in lored_list.loreds:
					add_applied_method(lored.output.increase_multiplied)
					add_removed_method(lored.output.decrease_multiplied)
			[LORED.Attribute.OUTPUT, LORED.Attribute.INPUT]:
				text = LoudString.new("Output and Input [b]x%s")
				for lored in lored_list.loreds:
					add_applied_method(lored.output.increase_multiplied)
					add_removed_method(lored.output.decrease_multiplied)
					add_applied_method(lored.input.increase_multiplied)
					add_removed_method(lored.input.decrease_multiplied)
			[LORED.Attribute.INPUT]:
				text = LoudString.new("Input [b]x%s")
				for lored in lored_list.loreds:
					add_applied_method(lored.input.increase_multiplied)
					add_removed_method(lored.input.decrease_multiplied)
			[LORED.Attribute.FUEL]:
				text = LoudString.new("Max Fuel [b]x%s")
				for lored in lored_list.loreds:
					add_applied_method(lored.fuel.increase_multiplied)
					add_removed_method(lored.fuel.decrease_multiplied)
			[LORED.Attribute.FUEL_COST]:
				text = LoudString.new("Fuel Cost [b]x%s")
				for lored in lored_list.loreds:
					add_applied_method(lored.fuel_cost.increase_multiplied)
					add_removed_method(lored.fuel_cost.decrease_multiplied)
			[LORED.Attribute.CRIT]:
				text = LoudString.new("Crit Chance [b]+%s%%")
				for lored in lored_list.loreds:
					add_applied_method(lored.crit.increase_added)
					add_removed_method(lored.crit.decrease_added)
		update_text()
	
	
	
	func update_text() -> void:
		text.set_to(text.base % value.value.get_text())



class LOREDSpecificInput:
	extends UpgradeMethods.WithValue
	
	#region Sub-Classes (Haste, Output, Crit.Dynamic)
	
	class Dynamic:
		extends LOREDSpecificInput
		
		
		func _init(_lored_types: Array[LORED.Type], _value: float, _input: Currency.Type):
			super(_lored_types, _value, _input)
			value.dynamic = true
	
	#endregion
	
	var attributes: Array[LORED.Attribute]
	var lored_list: LOREDList
	
	func _init(_lored_types: Array[LORED.Type], _value: float, _input: Currency.Type) -> void:
		super(Type.LORED_ATTRIBUTE)
		value = UpgradeValue.new(_value)
		value.value.changed.connect(refresh)
		value.value.changed.connect(update_text)
		value.value.changed.connect(emit_changed)
		applied.became_true.connect(apply_methods)
		applied.became_false.connect(remove_methods)
		applied.became_false.connect(value.value.reset)
		set_lored_recipients_text(_lored_types)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		has_value = true
		for lored in lored_list.loreds:
			for att in lored.get_attributes_by_currency(_input):
				add_applied_method(att.increase_multiplied)
				add_removed_method(att.decrease_multiplied)
		text = LoudString.new(wa.get_icon_and_name_text(_input) + " Input [b]x%s")
		update_text()
	
	
	
	func update_text() -> void:
		text.set_to(text.base % value.value.get_text())



class LOREDAutobuyer:
	extends UpgradeMethods.WithoutValue
	
	var lored_list: LOREDList
	
	func _init(_lored_types: Array[LORED.Type]) -> void:
		super(Type.LORED_AUTOBUYER)
		applied.became_true.connect(apply_methods)
		applied.became_false.connect(remove_methods)
		set_lored_recipients_text(_lored_types)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		for lored in lored_list.loreds:
			add_applied_method(lored.autobuy.set_true)
			add_removed_method(lored.autobuy.set_false)
		text = LoudString.new("Autobuyer")



class FreeLORED:
	extends UpgradeMethods.WithoutValue
	
	var lored_list: LOREDList
	
	func _init(_lored_types: Array[LORED.Type]) -> void:
		super(Type.LORED_AUTOBUYER)
		applied.became_true.connect(apply_methods)
		applied.became_false.connect(remove_methods)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		for lored in lored_list.loreds:
			add_applied_method(lored.purchased.set_reset_value_true)
			add_removed_method(lored.purchased.set_reset_value_false)


#endregion



enum Type {
	LORED_ATTRIBUTE,
	LORED_SPECIFIC_INPUT,
	LORED_AUTOBUYER,
}

var type: Type:
	set(val):
		type = val
		key = Type.keys()[type]
var key: String
var applied := LoudBool.new(false)
var text: LoudString
var recipients_text: String

var has_lored_list := false
var has_value := false



func _init(_type: Type) -> void:
	type = _type



# - Internal


func set_lored_recipients_text(_lored_types: Array[LORED.Type]) -> void:
	if _lored_types == lv.get_loreds_in_stage(1):
		var _stage = gv.stage1.details.colored_name
		recipients_text = "[i]for [/i]" + _stage
	elif _lored_types == lv.get_loreds_in_stage(2):
		var _stage = gv.stage2.details.colored_name
		recipients_text = "[i]for [/i]" + _stage
	elif _lored_types == lv.get_loreds_in_stage(3):
		var _stage = gv.stage3.details.colored_name
		recipients_text = "[i]for [/i]" + _stage
	elif _lored_types == lv.get_loreds_in_stage(4):
		var _stage = gv.stage4.details.colored_name
		recipients_text = "[i]for [/i]" + _stage
	else:
		var arr := []
		for lored_type in _lored_types:
			arr.append(lv.get_colored_name(lored_type))
		recipients_text = "[i]for [/i]" + gv.get_list_text_from_array(arr).replace("and", "[i]and[/i]")



# - Actions


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


func get_text() -> String:
	return text.get_value()


func get_recipients_text() -> String:
	return recipients_text
