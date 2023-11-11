class_name FlowerSeed
extends Resource



const saved_vars := ["count", "type"]

var count: Int
var name: String



func _init(_count: int = 1, roll_bonus: int = 0) -> void:
	count = Int.new(1)
	name = Flowers.get_random_flower(roll_bonus)





func sprout():
	Flowers.add_flower(name, count.get_value())

