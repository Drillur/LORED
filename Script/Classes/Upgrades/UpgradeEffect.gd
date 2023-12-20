class_name UpgradeEffect
extends Resource



var saved_vars := []



#region Sub-Classes


class LOREDList:
	extends RefCounted
	
	var loreds: Array[LORED]
	var lored_text: String
	var equal_to_stage := -1
	
	func _init(_lored_types: Array[LORED.Type]) -> void:
		if _lored_types == lv.get_loreds_in_stage(1):
			equal_to_stage = 1
		elif _lored_types == lv.get_loreds_in_stage(2):
			equal_to_stage = 2
		elif _lored_types == lv.get_loreds_in_stage(3):
			equal_to_stage = 3
		elif _lored_types == lv.get_loreds_in_stage(4):
			equal_to_stage = 4
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
	
	var value # can be LoudFloat or Value
	var applied_value # can be float or Big
	
	
	func _init(base_value: float, big: bool) -> void:
		if big:
			value = Value.new(base_value)
		else:
			value = LoudFloat.new(base_value)
	
	
	func reset() -> void:
		value.reset()
	
	
	func get_value():
		applied_value = value.get_value()
		return applied_value
	
	
	func get_applied_value():
		return applied_value


class UpgradeMethods:
	extends UpgradeEffect
	
	
	var applied_methods: Array[Callable]
	var removed_methods: Array[Callable]
	
	var value: UpgradeValue:
		set(val):
			value = val
			has_value = true
			value.value.changed.connect(refresh_methods)
			value.value.changed.connect(emit_changed)
			applied.became_false.connect(value.value.reset)
	
	
	func _init(_type: Type) -> void:
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
			if value.get_applied_value() == null:
				return
			for method in removed_methods:
				method.call(value.get_applied_value())
		else:
			for method in removed_methods:
				method.call()
	
	
	func refresh_methods() -> void:
		remove_methods()
		apply_methods()
	
	
	func add_applied_method(method: Callable) -> void:
		if not method in applied_methods:
			applied_methods.append(method)
	
	
	func add_removed_method(method: Callable) -> void:
		if not method in removed_methods:
			removed_methods.append(method)


class LOREDAttribute:
	extends UpgradeMethods
	
	
	var attributes: Array[LORED.Attribute]
	var lored_list: LOREDList
	
	
	func _init(_lored_types: Array[LORED.Type], _value: float, _attributes: Array[LORED.Attribute]) -> void:
		attributes = _attributes
		super(Type.LORED_ATTRIBUTE)
		value = UpgradeValue.new(_value, false)
		value.value.changed.connect(update_text)
		set_lored_recipients_text(_lored_types)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
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
	extends UpgradeMethods
	
	
	var attributes: Array[LORED.Attribute]
	var lored_list: LOREDList
	
	
	func _init(_lored_types: Array[LORED.Type], _value: float, _input: Currency.Type) -> void:
		super(Type.LORED_ATTRIBUTE)
		value = UpgradeValue.new(_value, false)
		value.value.changed.connect(update_text)
		set_lored_recipients_text(_lored_types)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		for lored in lored_list.loreds:
			for att in lored.get_attributes_by_currency(_input):
				add_applied_method(att.increase_multiplied)
				add_removed_method(att.decrease_multiplied)
		text = LoudString.new(wa.get_icon_and_name_text(_input) + " Input [b]x%s")
		update_text()
	
	
	func update_text() -> void:
		text.set_to(text.base % value.value.get_text())


class FreeLORED:
	extends UpgradeMethods
	
	var lored_list: LOREDList
	
	func _init(_lored_types: Array[LORED.Type]) -> void:
		super(Type.FREE_LORED)
		lored_list = LOREDList.new(_lored_types)
		has_lored_list = true
		for lored in lored_list.loreds:
			add_applied_method(lored.purchased.set_reset_value_true)
			add_removed_method(lored.purchased.set_reset_value_false)


class ItsOnMe:
	extends UpgradeMethods
	
	
	class Growin:
		extends ItsOnMe
		
		
		func _init() -> void:
			super()
			var iron_ore: LORED = lv.get_lored(LORED.Type.IRON_ORE)
			add_applied_method(iron_ore.output.increase_multiplied)
			add_applied_method(iron_ore.input.increase_multiplied)
			add_removed_method(iron_ore.output.decrease_multiplied)
			add_removed_method(iron_ore.input.decrease_multiplied)
			var copper_ore: LORED = lv.get_lored(LORED.Type.COPPER_ORE)
			add_applied_method(copper_ore.output.increase_multiplied)
			add_applied_method(copper_ore.input.increase_multiplied)
			add_removed_method(copper_ore.output.decrease_multiplied)
			add_removed_method(copper_ore.input.decrease_multiplied)
	
	
	class Spreadin:
		extends ItsOnMe
		
		
		func _init() -> void:
			super()
			var iron: LORED = lv.get_lored(LORED.Type.IRON)
			add_applied_method(iron.output.increase_multiplied)
			add_applied_method(iron.input.increase_multiplied)
			add_removed_method(iron.output.decrease_multiplied)
			add_removed_method(iron.input.decrease_multiplied)
			var copper: LORED = lv.get_lored(LORED.Type.COPPER)
			add_applied_method(copper.output.increase_multiplied)
			add_applied_method(copper.input.increase_multiplied)
			add_removed_method(copper.output.decrease_multiplied)
			add_removed_method(copper.input.decrease_multiplied)
	
	
	const INCREASE := 0.01
	
	
	func _init():
		value = UpgradeValue.new(1.0, false)
		value.value.changed.connect(update_text)
		text = LoudString.new("[b]x%s")
		value.dynamic = true
		wa.get_currency(Currency.Type.GROWTH).increased_by_lored.connect(growth_increased_by_lored)
		update_text()
		super(Type.ITS_ON_ME)
	
	
	func growth_increased_by_lored(_amount) -> void:
		if applied.is_true():
			value.value.add(INCREASE)
	
	
	func update_text() -> void:
		text.set_to(text.base % value.value.get_text())


class Milkshake:
	extends UpgradeMethods
	
	
	const INCREASE := 0.01
	var coal = lv.get_lored(LORED.Type.COAL)
	var currency: Currency
	var lored_type := LORED.Type.COAL
	
	
	func _init() -> void:
		currency = wa.get_currency(Currency.Type.COAL) as Currency
		currency.decreased_by_lored.connect(coal_taken)
		value = UpgradeValue.new(1.0, false)
		value.value.changed.connect(update_text)
		value.dynamic = true
		add_applied_method(coal.output.increase_multiplied)
		add_removed_method(coal.output.decrease_multiplied)
		super(Type.MILKSHAKE)
		text = LoudString.new("[b]x%s")
		update_text()
	
	
	func coal_taken(_amount) -> void:
		if applied.is_true():
			value.value.add(INCREASE)
	
	
	func update_text() -> void:
		text.set_to(text.base % value.value.get_text())


class Autobuyer:
	extends UpgradeMethods
	
	
	class _LORED:
		extends Autobuyer
		
		
		var lored_type: LORED.Type
		
		
		func _init(_lored_type: LORED.Type):
			lored_type = _lored_type
			var lored = lv.get_lored(_lored_type)
			add_applied_method(lored.autobuy.set_true)
			add_removed_method(lored.autobuy.set_false)
			set_lored_recipients_text([_lored_type])
			super(Type.LORED_AUTOBUYER)
	
	
	class _UpgradeMenu:
		extends Autobuyer
		
		
		func _init(_upgrade_menu: UpgradeMenu.Type):
			await up.all_upgrades_initialized
			for upgrade_type in up.get_upgrades_in_menu(_upgrade_menu):
				var upgrade = up.get_upgrade(upgrade_type)
				add_applied_method(upgrade.enable_autobuy)
				add_removed_method(upgrade.disable_autobuy)
			var upmen = up.get_upgrade_menu(_upgrade_menu) as UpgradeMenu
			recipients_text = "[i]for [/i]" + upmen.details.colored_name
			super(Type.UPGRADE_AUTOBUYER)
	
	
	func _init(_type: Type) -> void:
		text = LoudString.new("Autobuyer")
		super(_type)


class BonusJobProduction:
	extends UpgradeEffect
	
	
	var modifier := 1.0
	var job: Job
	var currency_type: Currency.Type
	var lored_type: LORED.Type
	
	
	func _init(_job: Job, _cur: Currency.Type, _modifier: float) -> void:
		job = _job
		lored_type = job.lored
		currency_type = _cur
		modifier = _modifier
		applied.became_true.connect(applied_became_true)
		applied.became_false.connect(applied_became_false)
		var lored_name = lv.get_colored_name(job.lored)
		var pronoun_his = lv.get_lored(job.lored).pronoun_his
		var pronoun_he = lv.get_lored(job.lored).pronoun_he
		var job_name = "[i]" + job.name + "[/i]"
		var modifier_text := ""
		if modifier == 1.0:
			modifier_text = "an equal amount of"
		else:
			modifier_text = str(modifier).pad_decimals(1) + "x"
		var currency_name = wa.get_icon_and_name_text(_cur)
		text = LoudString.new("Whenever %s performs %s %s job, %s will produce %s %s." % [
			lored_name,
			pronoun_his,
			job_name,
			pronoun_he,
			modifier_text,
			currency_name
		])
	
	
	func applied_became_true() -> void:
		job.add_bonus_production(currency_type, modifier)
	
	
	func applied_became_false() -> void:
		job.remove_bonus_production(currency_type)


class UpgradeName:
	extends UpgradeEffect
	
	
	var lored_list := LOREDList.new(lv.get_loreds_in_stage(1))
	
	
	func _init():
		has_lored_list = true
		applied.became_true.connect(applied_became_true)
		applied.became_false.connect(applied_became_false)
		super(Type.UPGRADE_NAME)
	
	
	func applied_became_true() -> void:
		for lored in lored_list.loreds:
			lored.output_increase.multiply(1.1)
			lored.input_increase.multiply(1.1)
			lored.fuel_cost.increase_multiplied(10)
			lored.fuel.increase_multiplied(10)
			lored.fuel.fill_up()
	
	
	func applied_became_false() -> void:
		for lored in lored_list.loreds:
			lored.output_increase.divide(1.1)
			lored.input_increase.divide(1.1)
			lored.fuel_cost.decrease_multiplied(10)
			lored.fuel.decrease_multiplied(10)
			lored.fuel.fill_up()


class _Persist:
	extends UpgradeMethods
	
	
	class _Upgrade:
		extends _Persist
		
		
		func _init(_upgrade_types: Array[Upgrade.Type], _stage: Stage.Type):
			type = Type.UPGRADE_PERSIST
			for upgrade_type in _upgrade_types:
				var upgrade = up.get_upgrade(upgrade_type)
				add_applied_method(upgrade.persist.get("s" + str(_stage)).set_true)
				add_removed_method(upgrade.persist.get("s" + str(_stage)).set_false)
			super()
	
	
	class _LORED:
		extends _Persist
		
		
		func _init():
			type = Type.LORED_PERSIST
			super()
	
	
	func _init():
		text = LoudString.new("Persists")


class PrestigeNow:
	extends UpgradeEffect
	
	
	var stage: Stage.Type
	
	
	func _init(_stage: Stage.Type):
		type = Type.PRESTIGE_NOW
		stage = _stage
		applied.became_true.connect(applied_became_true)
	
	
	func applied_became_true() -> void:
		gv.prestige_now(stage)


#endregion



enum Type {
	PLACEHOLDER,
	LORED_ATTRIBUTE,
	LORED_SPECIFIC_INPUT,
	FREE_LORED,
	LORED_AUTOBUYER,
	LORED_PERSIST,
	UPGRADE_AUTOBUYER,
	UPGRADE_NAME,
	UPGRADE_PERSIST,
	ITS_ON_ME,
	MILKSHAKE,
	PRESTIGE_NOW,
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
var has_value := false:
	set(val):
		has_value = val
		if val:
			saved_vars.append("value")



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
