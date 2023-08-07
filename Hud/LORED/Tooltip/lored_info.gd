extends MarginContainer



@onready var title = %Title
@onready var title_bg = %"title bg"
@onready var icon = %Icon
@onready var icon_shadow = %Icon2

@onready var level = %Level
@onready var output = %output
@onready var input = %input
@onready var haste = %haste
@onready var crit = %crit
@onready var details = %Details
@onready var description = %Description

var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val



func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	await ready
	title.text = lored.name
	color = lored.color
	icon.texture = lored.icon
	icon_shadow.texture = icon.texture
	lored.level.add_notify_change_method(adjust_if_not_purchased, true)
	lored.level.add_notify_change_method(update_level, true)
	lored.output.add_notify_change_method(update_output, true)
	lored.input.add_notify_change_method(update_input, true)
	lored.haste.add_notify_change_method(update_haste, true)
	lored.crit.add_notify_change_method(update_crit, true)



func update_level() -> void:
	level.text = "Level " + "[b]" + lored.get_level_text()


func adjust_if_not_purchased() -> void:
	if not lored.purchased:
		details.hide()
		description.show()
		description.text = lored.description
	else:
		details.show()
		description.hide()
		lored.level.remove_notify_method(adjust_if_not_purchased)


func update_output() -> void:
	output.text = "Output: " + "[b]" + lored.get_output_text() + "[/b]x"


func update_input() -> void:
	input.text = "Input: " + "[b]" + lored.get_input_text() + "[/b]x"


func update_haste() -> void:
	haste.text = "Haste: " + "[b]" + lored.get_haste_text() + "[/b]x"


func update_crit() -> void:
	crit.text = "Crit: " + "[b]" + lored.get_crit_text() + "%"
