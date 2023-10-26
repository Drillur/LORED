class_name CurrencyVico
extends MarginContainer



@onready var count = %Count
@onready var rate = %Rate
@onready var threshold_text = %Threshold
@onready var icon = %Icon
@onready var icon_shadow = %"Icon Shadow"

var lored: LORED
var currency: Currency
var first_setup := true
var display_rate := true



func attach_lored(_lored: LORED) -> void:
	lored = _lored
	lored.active_currency.changed.connect(setup)
	setup()


func clear_lored() -> void:
	disconnect_calls()
	lored = null



func setup(cur: int = lored.active_currency.get_value()) -> void:
	if not first_setup:
		if cur != currency.type:
			disconnect_calls()
	
	first_setup = false
	currency = wa.get_currency(cur) as Currency
	icon.texture = currency.details.icon
	icon_shadow.texture = icon.texture
	count.self_modulate = currency.details.color
	currency.count.connect("changed", update_count)
	currency.net_rate.connect("changed", update_rate)
	
	if not SaveManager.load_finished.is_connected(update_count):
		SaveManager.connect("load_finished", update_count)
		SaveManager.connect("load_finished", update_rate)
	
	update_count()
	update_rate()
	
	show()


func disconnect_calls() -> void:
	currency.count.disconnect("changed", update_count)
	currency.net_rate.disconnect("changed", update_rate)



func hide_rate():
	display_rate = false
	rate.queue_free()
	currency.net_rate.disconnect("changed", update_rate)
	return self


func hide_threshold():
	threshold_text.queue_free()



func update_count() -> void:
	count.text = currency.get_count_text()


func update_rate() -> void:
	var _sign = "" if currency.positive_rate.is_true() else "-"
	rate.text = "[i]" + _sign + currency.net_rate.get_text() + "/s"
