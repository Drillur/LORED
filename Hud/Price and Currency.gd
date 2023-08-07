class_name PriceAndCurrency
extends MarginContainer



@onready var cost_text = %"Cost Text"
@onready var currency_text = %"Currency Text"
@onready var currency_name = %"Currency Name"
@onready var h_box_container = %HBoxContainer

signal currency_changed

var currency: Currency
var cost: Attribute



func _ready():
	if get_index() == 0:
		$MarginContainer.add_theme_constant_override("margin_top", 0)



func setup(_currency: int, _cost: Attribute) -> void:
	currency = wa.get_currency(_currency)
	cost = _cost
	if not is_node_ready():
		await ready
	
	h_box_container.modulate = currency.color
	currency_name.text = currency.icon_text + " " + currency.name
	currency.count.add_notify_change_method(set_currency_text, true) # true if in tooltip
	cost.add_notify_change_method(set_cost_text, true)



# - Action

func set_currency_text() -> void:
	currency_text.text = currency.get_count_text()
	emit_signal("currency_changed")


func set_cost_text() -> void:
	cost_text.text = cost.get_text()
	emit_signal("currency_changed")


func flash() -> void:
	gv.flash(self)


func flash_became_affordable() -> void:
	gv.flash(self, Color(0, 1, 0))



# - Get

func get_eta() -> Big:
	return currency.get_eta(cost.get_total())
