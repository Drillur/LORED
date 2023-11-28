class_name FlowerSeed
extends Resource



const saved_vars := ["count", "type"]

var count: LoudInt
var type: Currency.Type



func _init(_count: int = 1, roll_bonus: int = 0) -> void:
	count = LoudInt.new(1)
	type = Flowers.get_random_flower(roll_bonus)





func sprout():
	Flowers.add_flower(type, count.get_value())

