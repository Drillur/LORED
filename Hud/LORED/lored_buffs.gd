extends MarginContainer



@onready var title_bg = %"title bg"
@onready var buffs = %Buffs


var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val



func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	var buffs = Buffs.get_buffs(lored)
	await ready
	color = lored.details.color
