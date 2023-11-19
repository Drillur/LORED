class_name UnitAbilityTooltip
extends MarginContainer



@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var cost_text = %"cost text"
@onready var cooldown = %cooldown
@onready var description = %description

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val

var ability: UnitAbility



func _ready() -> void:
	pass



func setup(data: Dictionary) -> void:
	ability = data.ability
	if not is_node_ready():
		await ready
	title.text = ability.details.name
	cost_text.text = ability.get_cost_text()
	if "{currency_cost}" in ability.cost_text:
		var currency = wa.get_currency(ability.cost.currency_cost.keys()[0]) as Currency
		currency.count.changed.connect(currency_changed)
	if ability.has_cooldown():
		cooldown.text = ability.cooldown.get_duration_text()
	else:
		cooldown.hide()
	description.text = ability.get_description()


func currency_changed() -> void:
	cost_text.text = ability.get_cost_text()
