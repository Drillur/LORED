extends MarginContainer



@onready var currency_name = %"Currency Name"
@onready var value = %value

var color: Color:
	set(val):
		color = val
		value.self_modulate = val


func setup(val: Value, _cur: int) -> void:
	if not is_node_ready():
		await ready
	value.text = val.get_text()
	var currency = wa.get_currency(_cur)
	currency_name.text = currency.icon_and_name_text
	color = currency.color
