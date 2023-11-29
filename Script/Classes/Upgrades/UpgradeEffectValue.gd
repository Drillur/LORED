class_name UpgradeEffectValue
extends RefCounted



var value: LoudFloat
var applied_value: float



func _init(_value: float):
	value = LoudFloat.new(_value)




func get_value() -> float:
	applied_value = value.get_value()
	return applied_value


func get_applied_value() -> float:
	return applied_value
