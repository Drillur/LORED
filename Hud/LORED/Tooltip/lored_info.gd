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

@onready var fuel = %Fuel
@onready var fuel_text = %"Fuel Text"
@onready var fuel_currency_text = %"Fuel Currency"
@onready var fuel_cost = %"Fuel Cost"
@onready var fuel_title_bg = %"fuel title bg"

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
	lored.connect("purchased_changed", purchased_changed)
	purchased_changed(lored.purchased)
	lored.level.add_notify_change_method(update_level, true)
	lored.output.add_notify_change_method(update_output, true)
	lored.input.add_notify_change_method(update_input, true)
	lored.haste.add_notify_change_method(update_haste, true)
	lored.crit.add_notify_change_method(update_crit, true)
	
	fuel_text.setup(lored.fuel)
	color = lored.color
	fuel_title_bg.self_modulate = lored.fuel_currency.color
	fuel_currency_text.text = lored.fuel_currency.icon_and_name_text
	lored.fuel_cost.add_notify_change_method(update_fuel_cost, true)



func update_fuel_cost() -> void:
	fuel_cost.text = "Fuel cost: [b]" + lored.fuel_cost.get_total_text() + "[/b]/s"



func update_level() -> void:
	level.text = "Level " + "[b]" + lored.get_level_text()


func purchased_changed(purchased: bool) -> void:
	if purchased:
		details.show()
		description.hide()
		fuel.show()
	else:
		fuel.hide()
		details.hide()
		description.show()
		description.text = lored.description


func update_output() -> void:
	output.text = "Output: " + "[b]" + lored.get_output_text() + "[/b]x"


func update_input() -> void:
	input.text = "Input: " + "[b]" + lored.get_input_text() + "[/b]x"


func update_haste() -> void:
	haste.text = "Haste: " + "[b]" + lored.get_haste_text() + "[/b]x"


func update_crit() -> void:
	crit.text = "Crit: " + "[b]" + lored.get_crit_text() + "%"
