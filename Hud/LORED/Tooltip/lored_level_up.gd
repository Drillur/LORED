extends MarginContainer



@onready var title = %Title
@onready var title_bg = %"title bg"
@onready var price = %Price as PriceVico
@onready var current_level = %"Current Level"
@onready var next_level = %"Next Level"
@onready var current_output = %"Current Output"
@onready var next_output = %"Next Output"
@onready var current_input = %"Current Input"
@onready var next_input = %"Next Input"
@onready var current_fuel_cost = %"Current Fuel Cost"
@onready var next_fuel_cost = %"Next Fuel Cost"
@onready var current_max_fuel = %"Current Max Fuel"
@onready var next_max_fuel = %"Next Max Fuel"
@onready var details = %Details
@onready var description = %Description
@onready var details_container = %"Details Container"
@onready var output_increase = %OutputIncrease
@onready var input_increase = %InputIncrease

var flash_allowed := false
var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val



func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	await ready
	color = lored.details.color
	
	price.setup(lored.cost)
	price.color = color
	
	lored.purchased.became_true.connect(just_purchased)
	lored.level.changed.connect(set_level_text)
	
	just_purchased()
	
	set_level_text()
	
	flash_allowed = true


func just_purchased() -> void:
	if lored.times_purchased == 0:
		details.hide()
		show_advanced_details(false)
		title.text = "Invite"
		description.show()
		description.text = "[center]Ask " + lored.details.colored_name + " to join you!"
		if randi() % 100 < 10:
			var pool = [
				"Bribe " + lored.details.colored_name + " to join you!",
				"Ask " + lored.details.colored_name  + " to join you (as if they had a choice)!",
				"Ask " + lored.details.colored_name  + " to join you (but not for free)!",
				"Force " + lored.details.colored_name  + " to join you!",
				"Threaten " + lored.details.colored_name  + " into joining you!",
				"Ask " + lored.details.colored_name  + " very nicely to join you!",
				"Jump-scare " + lored.details.colored_name  + " into joining you!",
				"Provide intimate favors for " + lored.details.colored_name  + " so that " + lored.pronoun_he + "'ll join you!",
				"Promise " + lored.details.colored_name  + " the largest share of the booty if " + lored.pronoun_he + " joins!",
			]
			#description.custom_minimum_size.x = 150
			description.text = "[center]" + pool[randi() % pool.size()]
			description.autowrap_mode = 2
	else:
		details.show()
		description.hide()
		title.text = "Level Up"
		lored.purchased.became_true.disconnect(just_purchased)
		if lv.advanced_details_unlocked.is_true():
			lored.output.connect("changed", set_output_text)
			lored.input.connect("changed", set_input_text)
			lored.fuel_cost.connect("changed", set_fuel_cost_text)
			lored.fuel.total.changed.connect(set_max_fuel_text)
			lored.output_increase.changed.connect(set_output_increase)
			lored.input_increase.changed.connect(set_input_increase)
			set_output_text()
			set_input_text()
			set_fuel_cost_text()
			set_max_fuel_text()
			set_output_increase()
			set_input_increase()
		else:
			show_advanced_details(false)


func show_advanced_details(_show: bool) -> void:
	for node in details.get_children():
		if not "Level" in node.name:
			node.visible = _show


func set_level_text() -> void:
	current_level.text = lored.get_level_text()
	next_level.text = str(lored.level.get_value() + 1)
	if flash_allowed:
		gv.flash(details_container, lored.details.color)


func set_output_text() -> void:
	current_output.text = lored.get_output_text()# + "x"
	next_output.text = lored.get_next_output_text()# + "x"


func set_output_increase() -> void:
	output_increase.text = "x" + lored.output_increase.text


func set_input_text() -> void:
	current_input.text = lored.get_input_text()# + "x"
	next_input.text = lored.get_next_input_text()# + "x"


func set_input_increase() -> void:
	input_increase.text = "x" + lored.input_increase.text


func set_fuel_cost_text() -> void:
	current_fuel_cost.text = lored.get_fuel_cost_text()# + "x"
	next_fuel_cost.text = lored.get_next_fuel_cost_text()# + "x"


func set_max_fuel_text() -> void:
	current_max_fuel.text = lored.get_max_fuel_text()
	next_max_fuel.text = lored.get_next_max_fuel_text()



# - Get

func get_price_node() -> PriceVico:
	return price
