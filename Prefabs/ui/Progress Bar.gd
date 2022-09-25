extends MarginContainer



onready var current = get_node("total/current")
onready var total = get_node("total")

var value: float setget setValue
var color: Color setget setColor



func setValue(percent: float):
	# from 0.00 to 1.00
	current.rect_size.x = min(percent * total.rect_size.x, total.rect_size.x)

func setColor(val: Color):
	current.modulate = val
	#get_node("Text/Label").self_modulate = val

