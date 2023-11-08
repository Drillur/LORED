extends MarginContainer



@onready var currency_name = %"Currency Name"
@onready var value = %value

var is_a_produced_currency: bool
var val: Value

var color: Color:
	set(_val):
		color = _val
		value.self_modulate = _val


func setup(_val: Value, _cur: int, _is_a_produced_currency: bool) -> void:
	val = _val
	is_a_produced_currency = _is_a_produced_currency
	var currency = wa.get_currency(_cur)
	if not is_node_ready():
		await ready
	
	currency_name.text = currency.details.icon_and_name_text
	color = currency.details.color
	val.changed.connect(update_text)
	update_text()


func update_text() -> void:
	value.text = ("+" if is_a_produced_currency else "-") + val.get_text()
