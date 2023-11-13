class_name UnitResource
extends Resource



enum Type {
	HEALTH,
	STAMINA,
	MANA,
	BLOOD,
}

signal increased
signal decreased


var type: Type
var value: FloatPair
var details := Details.new()



func _init(_type: Type, base_value: float):
	type = _type
	value = FloatPair.new(base_value, base_value)
	value.current.increased.connect(value_increased)
	value.current.decreased.connect(value_decreased)
	value.current.changed.connect(emit_changed)
	value.total.changed.connect(emit_changed)
	match type:
		Type.STAMINA:
			details.name = "Stamina"
			details.description = "A quickly regenerating resource used for many abilities."
			details.icon = res.get_resource("Stamina")
	details.color = UnitResource.get_color(type)



func add(amount: float) -> void:
	value.add(amount)


func subtract(amount: float) -> void:
	value.subtract(amount)


func value_increased() -> void:
	increased.emit()


func value_decreased() -> void:
	decreased.emit()



# - Get


static func get_color(_type: Type) -> Color:
	match _type:
		Type.STAMINA:
			return Color.GREEN_YELLOW
		_:
			return Color.WHITE


func get_value() -> float:
	return value.get_value()
