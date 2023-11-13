class_name Hotbar
extends MarginContainer



@onready var currency_0_text = %Currency0
@onready var currency_1_text = %Currency1

var unit: Unit
var currency_0: Currency
var currency_1: Currency



func _ready() -> void:
	pass



func setup(_unit: Unit) -> void:
	if unit:
		disconnect_currencies()
	unit = _unit
	connect_currencies()


func connect_currencies() -> void:
	var i := 0
	for cur in unit.hotbar_currencies:
		set("currency_" + str(i), wa.get_currency(cur))
	if currency_0:
		currency_0.count.changed.connect(currency_0_changed)
	if currency_1:
		currency_1.count.changed.connect(currency_1_changed)


func disconnect_currencies() -> void:
	if currency_0:
		currency_0.count.changed.disconnect(currency_0_changed)
		currency_0 = null
	if currency_1:
		currency_1.count.changed.disconnect(currency_1_changed)
		currency_1 = null



# - Signal


func currency_0_changed() -> void:
	currency_0_text.text = "%s: %s" % [currency_0.details.get_icon_and_name(), currency_0.count.get_text()]


func currency_1_changed() -> void:
	currency_1_text.text = "%s: %s" % [currency_1.details.get_icon_and_name(), currency_1.count.get_text()]
