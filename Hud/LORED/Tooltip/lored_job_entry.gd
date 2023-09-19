extends MarginContainer



@onready var currency_name = %"Currency Name"
@onready var value = %value

var color: Color:
	set(val):
		color = val
		value.self_modulate = val


func setup(val: Value, _cur: int, is_a_produced_currency: bool) -> void:
	if not is_node_ready():
		await ready
	value.text = ("+" if is_a_produced_currency else "-") + val.get_text()
	var currency = wa.get_currency(_cur)
	currency_name.text = currency.details.icon_and_name_text
	color = currency.details.color
