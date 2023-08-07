extends MarginContainer



@onready var attribute = %Attribute
@onready var currency_name = %"Currency Name"



func setup(_att: Attribute, _cur: int, is_a_produced_currency: bool) -> void:
	if not is_node_ready():
		await ready
	attribute.setup(_att, "+" if is_a_produced_currency else "-")
	var currency = wa.get_currency(_cur)
	currency_name.text = currency.icon_and_name_text
	attribute.modulate = currency.color
