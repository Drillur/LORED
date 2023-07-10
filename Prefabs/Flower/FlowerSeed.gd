class_name FlowerSeed
extends Reference



var saved_vars := ["count", "type"]

var count: int
var type: String



func _init(_count: int = 1, roll_bonus: int = 0) -> void:
	count = _count
	type = Flower.get_random_flower(roll_bonus)



func get_name() -> String:
	return type



func sprout():
	Flower.add_flower(type, count)

