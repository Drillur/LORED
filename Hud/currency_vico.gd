class_name CurrencyVico
extends MarginContainer



signal showed_or_removed
func _on_visibility_changed():
	if visible:
		emit_signal("showed_or_removed")
func _on_tree_exited():
	emit_signal("showed_or_removed")


@onready var count = %Count
@onready var rate = %Rate
@onready var threshold_text = %Threshold
@onready var icon = %Icon
@onready var icon_shadow = %"Icon Shadow"

var currency: Currency
var threshold: Attribute

var first_setup := true

var display_rate := true



func setup(_currency: int) -> void:
	if not first_setup:
		if _currency == currency.type:
			return
		currency.count.disconnect("changed", update_count)
		currency.net_rate.disconnect("changed", update_rate)
	
	first_setup = false
	currency = wa.get_currency(_currency) as Currency
	icon.texture = currency.icon
	icon_shadow.texture = icon.texture
	count.self_modulate = currency.color
	currency.count.connect("changed", update_count)
	currency.net_rate.connect("changed", update_rate)
	
	SaveManager.connect("load_finished", update_count)
	SaveManager.connect("load_finished", update_rate)
	
	update_count()
	update_rate()



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
	if currency.net_rate.get_total().equal(0):
		rate.hide()
		return
	else:
		rate.show()
	var _sign = "" if currency.positive_total_rate else "-"
	rate.text = "[i]" + _sign + currency.net_rate.get_total_text() + "/s"


func update_threshold() -> void:
	threshold_text.text = "/" + threshold.get_total_text()
