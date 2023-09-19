class_name WalletCurrency
extends MarginContainer



@onready var count = %Count
@onready var rate = %Rate
@onready var icon_and_name = %"Icon and Name"
@onready var check = %Check
@onready var button = %Button

signal mouse_entered_custom(cur)

var currency: Currency



func _ready() -> void:
	button.mouse_exited.connect(gv.clear_tooltip)



func _on_mouse_entered():
	mouse_entered_custom.emit(currency.type)



func setup(cur: int) -> void:
	currency = wa.get_currency(cur) as Currency
	name = currency.details.name
	
	if not is_node_ready():
		await ready
	
	count.self_modulate = currency.details.color
	rate.self_modulate = currency.details.color
	check.self_modulate = currency.details.color
	
	icon_and_name.text = currency.details.icon_text + " " + currency.details.colored_name
	
	currency.unlocked_changed.connect(display_and_update)
	display_and_update(currency.unlocked)


func display_and_update(unlocked: bool) -> void:
	if unlocked:
		show()
		currency.count.connect("changed", update_count)
		currency.net_rate.connect("changed", update_rate)
		update_count()
		update_rate()
	else:
		hide()
		if currency.count.changed.is_connected(update_count):
			currency.count.disconnect("changed", update_count)
			currency.net_rate.disconnect("changed", update_rate)



func _on_button_pressed():
	check.button_pressed = not check.button_pressed
	currency.use_allowed = check.button_pressed



func update_count() -> void:
	count.text = currency.get_count_text()


func update_rate() -> void:
	if currency.net_rate.current.equal(0):
		rate.text = "[i]0/s"
		return
	var _sign = "" if currency.positive_rate else "-"
	rate.text = "[i]" + _sign + currency.net_rate.get_text() + "/s"


