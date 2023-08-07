extends MarginContainer



@onready var title_bg = %"title bg"
@onready var fuel = %Fuel as AttributeTextVico
@onready var fuel_currency_text = %"Fuel Currency"
@onready var icon = %Icon
@onready var fuel_cost = %"Fuel Cost"

var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val



func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	await ready
	fuel.setup(lored.fuel)
	color = lored.color
	icon.texture = lored.fuel_currency.icon
	fuel_currency_text.text = lored.fuel_currency.colored_name
	lored.fuel_cost.add_notify_change_method(update_fuel_cost, true)


func update_fuel_cost() -> void:
	fuel_cost.text = "Fuel cost: [b]" + lored.fuel_cost.get_total_text() + "[/b]/s"
