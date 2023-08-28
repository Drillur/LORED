extends MarginContainer



@onready var name_label = %Name
@onready var title = %Title
@onready var title_bg = %"title bg"

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

@onready var advanced_details = %"Advanced Details"
@onready var advanced_fuel_details = %"Advanced Fuel Details"


var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val



func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	await ready
	name_label.text = lored.name + ","
	title.text = lored.title
	color = lored.color
	lored.connect("just_purchased", just_purchased)
	lored.connect("leveled_up", update_level)
	just_purchased()
	update_level(lored.level)
	if lv.advanced_details_unlocked or gv.dev_mode:
		advanced_details.show()
		advanced_fuel_details.show()
		lored.output.connect("changed", update_output)
		lored.input.connect("changed", update_input)
		lored.haste.connect("changed", update_haste)
		lored.crit.connect("changed", update_crit)
		lored.fuel_cost.connect("changed", update_fuel_cost)
		update_output()
		update_input()
		update_haste()
		update_crit()
		update_fuel_cost()
		fuel_currency_text.text = wa.get_icon_and_name_text(lored.fuel_currency)
	else:
		advanced_details.hide()
		advanced_fuel_details.hide()
	
	fuel_text.setup(lored.fuel)
	fuel_title_bg.self_modulate = wa.get_color(lored.fuel_currency)



func update_fuel_cost() -> void:
	fuel_cost.text = "Fuel cost: [b]" + lored.fuel_cost.get_text() + "[/b]/s"



func update_level(_level: int) -> void:
	level.text = "Level " + "[b]" + lored.get_level_text()


func just_purchased() -> void:
	if lored.purchased:
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
