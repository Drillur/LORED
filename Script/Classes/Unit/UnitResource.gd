class_name UnitResource
extends Resource



enum Type {
	HEALTH,
	STAMINA,
	MANA,
	BLOOD,
}


var type: Type
var value: FloatPair
var recovery_rate: Float
var details := Details.new()



func _init(_type: Type, base_value: float):
	type = _type
	value = FloatPair.new(base_value, base_value)
	match type:
		Type.STAMINA:
			details.name = "Stamina"
			details.description = "A quickly regenerating resource used for many abilities."
			details.icon = res.get_resource("Stamina")
			recovery_rate = Float.new(5/3)
		Type.MANA:
			details.name = "Mana"
			details.description = "A slowly regenerating resource used for advanced abilities."
			details.icon = res.get_resource("water")
			recovery_rate = Float.new(1/3)
		Type.HEALTH:
			details.name = "Health"
			details.description = "This unit's ability to recover. If it drops to 0, he or she will be incapable of recovering and effectively be dead."
			details.icon = res.get_resource("carc")
		Type.BLOOD:
			details.name = "Blood"
			details.description = "The blood flowing through this unit's veins."
			details.icon = res.get_resource("malig")
	details.color = UnitResource.get_color(type)



func add(amount: float) -> void:
	value.add(amount)


func subtract(amount: float) -> void:
	value.subtract(amount)



# - Get


static func get_color(_type: Type) -> Color:
	match _type:
		Type.STAMINA:
			return Color.GREEN_YELLOW
		Type.HEALTH:
			return Color.GREEN
		Type.BLOOD:
			return Color.RED
		Type.MANA:
			return Color(0.721569, 0.34902, 0.901961)
		_:
			return Color.WHITE


func get_value() -> float:
	return value.get_value()


func recovers_over_time() -> bool:
	return recovery_rate != null
