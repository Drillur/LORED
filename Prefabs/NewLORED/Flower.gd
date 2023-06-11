extends MarginContainer



onready var icon: Panel = $icon
onready var count: Label = $"%count"

var flower: String



func setup(_flower: String):
	
	flower = _flower
	
	set_name(flower)
	
	hide()
	
	yield(self, "ready")
	
	set_icon()
	$Button.hint_tooltip = Flower.get_flower_name(flower)


func set_icon():
	if flower in Flower.Icons:
		icon.set_icon(Flower.Icons[flower])
	if flower in Flower.Colors:
		icon.modulate = Flower.Colors[flower]



func update_count():
	var _count = Flower.get_flower_count(flower)
	count.text = str(_count)
	set_visibility_based_on_count(_count)


func set_visibility_based_on_count(_count: int):
	visible = _count > 0
