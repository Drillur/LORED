class_name WalletCurrency
extends MarginContainer



signal showed_or_removed
func _on_visibility_changed():
	if visible:
		emit_signal("showed_or_removed")
func _on_tree_exited():
	emit_signal("showed_or_removed")


@onready var count = %Count
@onready var rate = %Rate
@onready var icon_and_name = %"Icon and Name"
@onready var check = %Check
@onready var button = %Button

var currency: Currency



func setup(cur: int) -> void:
	currency = wa.get_currency(cur) as Currency
	
	if not is_node_ready():
		await ready
	
	count.self_modulate = currency.color
	rate.self_modulate = currency.color
	check.self_modulate = currency.color
	
	icon_and_name.text = currency.icon_text + " " + currency.colored_name
	
	if not currency.unlocked:
		hide()
		await currency.just_unlocked
	
	show()
	currency.count.add_notify_change_method(update_count)
	currency.net_rate.add_notify_change_method(update_rate)



func _on_button_pressed():
	check.button_pressed = not check.button_pressed



func update_count() -> void:
	count.text = currency.get_count_text()


func update_rate() -> void:
	if currency.net_rate.get_total().equal(0):
		rate.text = "[i]0/s"
		return
	var _sign = "" if currency.positive_total_rate else "-"
	rate.text = "[i]" + _sign + currency.net_rate.get_total_text() + "/s"


