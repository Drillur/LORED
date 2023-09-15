extends MarginContainer



@onready var currency_name = %"Currency Name"
@onready var value = %value

var currency: Currency

var color: Color:
	set(val):
		color = val
		value.self_modulate = val


func setup(_cur: int) -> void:
	currency = wa.get_currency(_cur)
	if not is_node_ready():
		await ready
	value.text = currency.offline_production.text
	currency_name.text = currency.icon_and_name_text
	color = currency.color
