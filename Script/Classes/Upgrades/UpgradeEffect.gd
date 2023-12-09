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
	
	
	
	class Float:
		extends UpgradeValue
		
		
		var value: LoudFloat
		var applied_value: float
		
		
		
		func _init(base_value: float):
			value = LoudFloat.new(base_value)
		
		
		func reset() -> void:
			value.reset()
		
		
		func get_value() -> float:
			applied_value = value.get_value()
			return applied_value
		
		
		func get_applied_value() -> float:
			return applied_value
	
	
	
	class _Big:
		extends UpgradeValue
		
		
		var value: Value
		var applied_value: Big
		
		
		
		func _init(base_value: float):
			value = Value.new(base_value)
		
		
		func reset() -> void:
			value.reset()
		
		
		func get_value() -> Big:
			applied_value = Big.new(value.get_value())
			return applied_value
		
		
		func get_applied_value() -> Big:
			return applied_value
	
	
	
	var saved_vars := []
	
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


class UpgradeMethods:
	extends UpgradeEffect
	
	#region Sub-Classes
	class WithValue:
		extends UpgradeMethods
		
		
		var value: UpgradeValue.Float:
			set(val):
				value = val
				value.value.changed.connect(refresh_methods)
				value.value.changed.connect(emit_changed)
				applied.became_false.connect(value.value.reset)
		
		
		func _init(_type: Type) -> void:
			super(_type)
			applied.became_true.connect(apply_methods)
			applied.became_false.connect(remove_methods)
		
		
		func apply_methods() -> void:
			for method in applied_methods:
				method.call(value.get_value())
		
		
		func remove_methods() -> void:
			for method in removed_methods:
				method.call(value.get_applied_value())
		
		
		func refresh_methods() -> void:
			remove_methods()
			apply_methods()
	
	
	class WithoutValue:
		extends UpgradeMethods
		
		
		func _init(_type: Type) -> void:
			super(_type)
			applied.became_true.connect(apply_methods)
			applied.became_false.connect(remove_methods)
		
		
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
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.HASTE]
			super(_lored_types, _value)
	
	
	class Output:
		extends LOREDAttribute
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.OUTPUT]
			super(_lored_types, _value)
	
	
	class OutputAndInput:
		extends LOREDAttribute
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.OUTPUT, LORED.Attribute.INPUT]
			super(_lored_types, _value)
	
	
	class _Input:
		extends LOREDAttribute
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.INPUT]
			super(_lored_types, _value)
	
	
	class Fuel:
		extends LOREDAttribute
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.FUEL]
			super(_lored_types, _value)
	
	
	class FuelCost:
		extends LOREDAttribute
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.FUEL_COST]
			super(_lored_types, _value)
	
	
	class Crit:
		extends LOREDAttribute
		func _init(_lored_types: Array[LORED.Type], _value: float):
			attributes = [LORED.Attribute.CRIT]
			super(_lored_types, _value)
	
	#endregion
	
	var attributes: Array[LORED.Attribute]
	var lored_list: LOREDList
	
	func _init(_lored_types: Array[LORED.Type], _value: float) -> void:
		super(Type.LORED_ATTRIBUTE)
		value = UpgradeValue.Float.new(_value)
		value.value.changed.connect(update_text)
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
		value = UpgradeValue.Float.new(_value)
		value.value.changed.connect(update_text)
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
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		for lored in lored_list.loreds:
			add_applied_method(lored.purchased.set_reset_value_true)
			add_removed_method(lored.purchased.set_reset_value_false)


class ActionOnCurrencyGain:
	extends UpgradeEffect
	
	
	class ItsOnMe:
		extends ActionOnCurrencyGain
		
		
		class Growin:
			extends ItsOnMe
			
			
			
			var value2 := UpgradeValue._Big.new(1.0)
			var spreadin_applied: LoudBool
			
			
			
			func _init() -> void:
				value2.dynamic = true
				value1.value.changed.connect(refresh_value_1)
				value1.value.changed.connect(update_text)
				value2.value.changed.connect(refresh_value_2)
				value2.value.changed.connect(update_text)
				applied.became_false.connect(remove_value_1)
				applied.became_true.connect(apply_value_1)
				applied.became_false.connect(remove_value_2)
				applied.became_true.connect(apply_value_2)
				value2.value.changed.connect(emit_changed)
				spreadin_applied = up.get_upgrade(Upgrade.Type.ITS_SPREADIN_ON_ME).effect.applied
				spreadin_applied.became_true.connect(remove_value_1)
				spreadin_applied.became_true.connect(remove_value_2)
				spreadin_applied.became_false.connect(apply_value_1)
				spreadin_applied.became_false.connect(apply_value_1)
				super()
				currency.increased_by_lored.connect(currency_increased_by_lored)
				var iron_text = iron.details.icon_and_colored_name + ": [b]x%s"
				var copper_text = copper.details.icon_and_colored_name + ": [b]x%s"
				text = LoudString.new(iron_text + "\n" + copper_text)
				update_text()
			
			
			func apply_value_1() -> void:
				if applied.is_true() and spreadin_applied.is_false():
					iron.output.increase_multiplied(value1.get_value())
			
			
			func remove_value_1() -> void:
				iron.output.decrease_multiplied(value1.get_applied_value())
			
			
			func refresh_value_1() -> void:
				print("refresh1")
				remove_value_1()
				apply_value_1()
			
			
			func apply_value_2() -> void:
				if applied.is_true() and spreadin_applied.is_false():
					copper.output.increase_multiplied(value2.get_value())
			
			
			func remove_value_2() -> void:
				copper.output.decrease_multiplied(value2.get_applied_value())
			
			
			func refresh_value_2() -> void:
				print("refresh2")
				remove_value_2()
				apply_value_2()
			
			
			func currency_increased_by_lored(amount: Big) -> void:
				if applied.is_true():
					var modded_amount = Big.new(amount).m(INCREASE).m(currency.last_crit_modifier)
					print("amount ", amount.text)
					print("INCREASE ", INCREASE)
					print("currency.last_crit_modifier ", currency.last_crit_modifier)
					print("modded amount: ", modded_amount.text)
					if randi() % 2 == 0:
						value1.value.add(modded_amount)
					else:
						value2.value.add(modded_amount)
			
			
			func update_text() -> void:
				print("value changed! ", value1.value.get_text())
				text.set_to(text.base % [value1.value.get_text(), value2.value.get_text()])
		
		
		class Spreadin:
			extends ItsOnMe
			
			
			
			var copper_ore := lv.get_lored(LORED.Type.COPPER_ORE)
			var iron_ore := lv.get_lored(LORED.Type.IRON_ORE)
			
			
			
			func _init() -> void:
				value1.value.changed.connect(refresh_value_1)
				value1.value.changed.connect(update_text)
				applied.became_false.connect(remove_value_1)
				applied.became_true.connect(apply_value_1)
				super()
				currency.increased_by_lored.connect(currency_increased_by_lored)
				text = LoudString.new("[b]x%s")
				update_text()
			
			
			func apply_value_1() -> void:
				iron.output.increase_multiplied(value1.get_value())
				copper.output.increase_multiplied(value1.get_value())
				iron_ore.output.increase_multiplied(value1.get_value())
				copper_ore.output.increase_multiplied(value1.get_value())
			
			
			func remove_value_1() -> void:
				iron.output.decrease_multiplied(value1.get_applied_value())
				copper.output.decrease_multiplied(value1.get_applied_value())
				iron_ore.output.decrease_multiplied(value1.get_applied_value())
				copper_ore.output.decrease_multiplied(value1.get_applied_value())
			
			
			func refresh_value_1() -> void:
				remove_value_1()
				apply_value_1()
			
			
			func currency_increased_by_lored(amount: Big) -> void:
				if applied.is_true():
					var modded_amount = Big.new(amount).m(INCREASE).m(currency.last_crit_modifier)
					value1.value.add(modded_amount)
			
			
			func update_text() -> void:
				text.set_to(text.base % value1.value.get_text())
		
		
		const INCREASE := 0.0001
		var value1 := UpgradeValue._Big.new(1.0)
		var iron := lv.get_lored(LORED.Type.IRON)
		var copper := lv.get_lored(LORED.Type.COPPER)
		
		
		func _init() -> void:
			value1.dynamic = true
			value1.value.changed.connect(emit_changed)
			super(Currency.Type.GROWTH)
	
	
	var currency: Currency
	
	
	func _init(_currency_type: Currency.Type) -> void:
		currency = wa.get_currency(_currency_type) as Currency


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
