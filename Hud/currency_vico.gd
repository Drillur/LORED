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



func setup(_currency: int, _threshold: Attribute = Attribute.new(0)) -> void:
	if not first_setup:
		if _currency == currency.type:
			return
		currency.count.remove_notify_method(update_count)
		currency.net_rate.remove_notify_method(update_rate)
	
	first_setup = false
	currency = wa.get_currency(_currency) as Currency
	icon.texture = currency.icon
	icon_shadow.texture = icon.texture
	currency.count.add_notify_change_method(update_count)
	currency.net_rate.add_notify_change_method(update_rate)
	count.self_modulate = currency.color
	
	if _threshold.total.current.greater(0):
		threshold = _threshold
		threshold_text.show()
		threshold.add_notify_change_method(update_threshold)



func hide_rate():
	display_rate = false
	rate.queue_free()
	currency.net_rate.remove_notify_method(update_rate)
	return self


func hide_threshold():
	threshold_text.queue_free()



func update_count() -> void:
	count.text = currency.get_count_text()


func update_rate() -> void:
	if currency.net_rate.get_current().equal(0):
		rate.hide()
		return
	else:
		rate.show()
	var _sign = "" if currency.positive_current_rate else "-"
	rate.text = "[i]" + _sign + currency.net_rate.get_current_text() + "/s"


func update_threshold() -> void:
	threshold_text.text = "/" + threshold.get_total_text()
