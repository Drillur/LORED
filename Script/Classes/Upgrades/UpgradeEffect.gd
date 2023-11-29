class_name UpgradeEffect
extends Resource



enum Type {
	LORED_HASTE,
	LORED_OUTPUT,
	LORED_OUTPUT_INPUT,
	LORED_INPUT,
}

var type: Type:
	set(val):
		type = val
		key = Type.keys()[type]
var key: String
var applied := LoudBool.new(false)

var upgrade_value: UpgradeEffectValue
var affected_loreds: UpgradeEffectLOREDs

var apply_methods: Array[Callable]
var remove_methods: Array[Callable]



func _init(_type: Type, data: Dictionary) -> void:
	type = _type
	
	if gv.dev_mode:
		# assert data has proper keys
		match type:
			Type.LORED_HASTE:
				assert("value" in data.keys())
				assert("affected_loreds" in data.keys())
	
	if data.has("value"):
		upgrade_value = UpgradeEffectValue.new(data["value"])
		upgrade_value.value.changed.connect(upgrade_value_changed)
	if data.has("affected_loreds"):
		affected_loreds = UpgradeEffectLOREDs.new(data["affected_loreds"])



# - Internal


func upgrade_value_changed() -> void:
	if applied.is_true():
		refresh()



# - Action


func apply():
	if applied.is_true():
		return
	applied.set_to(true)
	if has_upgrade_value():
		var applied_value = upgrade_value.get_value()
		for method in apply_methods:
			method.call(applied_value)


func remove():
	if applied.is_false():
		return
	applied.set_to(false)
	if has_upgrade_value():
		for method in remove_methods:
			method.call(upgrade_value.get_applied_value())


func refresh():
	remove()
	apply()



# - Get


func affects_loreds() -> bool:
	return "LORED" in key


func has_upgrade_value() -> bool:
	return upgrade_value != null
