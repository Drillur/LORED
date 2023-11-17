class_name Hotbar
extends MarginContainer



@onready var currency_0_text = %Currency0
@onready var currency_1_text = %Currency1
@onready var hotbar_slot_0 = %HotbarSlot0 as HotbarSlot
@onready var hotbar_slot_1 = %HotbarSlot1 as HotbarSlot
@onready var hotbar_slot_2 = %HotbarSlot2 as HotbarSlot
@onready var hotbar_slot_3 = %HotbarSlot3 as HotbarSlot
@onready var hotbar_slot_4 = %HotbarSlot4 as HotbarSlot
@onready var hotbar_slot_5 = %HotbarSlot5 as HotbarSlot
@onready var hotbar_slot_6 = %HotbarSlot6 as HotbarSlot
@onready var hotbar_slot_7 = %HotbarSlot7 as HotbarSlot
@onready var hotbar_slot_8 = %HotbarSlot8 as HotbarSlot
@onready var hotbar_slot_9 = %HotbarSlot9 as HotbarSlot
@onready var hotbar_slot_10 = %HotbarSlot10 as HotbarSlot
@onready var hotbar_slot_11 = %HotbarSlot11 as HotbarSlot
@onready var stamina_bar = %Stamina as Bar
@onready var mana_bar = %Mana as Bar

var unit: Unit
var currency_0: Currency
var currency_1: Currency



func _ready() -> void:
	stamina_bar.color = UnitResource.get_color(UnitResource.Type.STAMINA)
	stamina_bar.label_name.text = "Stamina"
	mana_bar.color = UnitResource.get_color(UnitResource.Type.MANA)
	mana_bar.label_name.text = "Mana"
	for i in 12:
		var hotbar_slot: HotbarSlot = get("hotbar_slot_" + str(i))
		hotbar_slot.hotkey_pressed.connect(hotkey_pressed)



func setup(_unit: Unit) -> void:
	if unit:
		disconnect_currencies()
		stamina_bar.remove_value()
		mana_bar.remove_value()
	unit = _unit
	connect_currencies()
	
	for resource in unit.resources:
		match resource:
			UnitResource.Type.STAMINA:
				stamina_bar.show()
				stamina_bar.attach_float_pair(unit.stamina.value)
			UnitResource.Type.MANA:
				mana_bar.show()
				mana_bar.attach_float_pair(unit.mana.value)
	
	var i = 0
	for ability in unit.abilities.values():
		var hotbar_slot: HotbarSlot = get("hotbar_slot_" + str(i))
		hotbar_slot.setup(ability)
		i += 1


func connect_currencies() -> void:
	var i := 0
	for currency in unit.hotbar_currencies:
		set("currency_" + str(i), currency)
		i += 1
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


func hotkey_pressed(ability: UnitAbility) -> void:
	ability.unit.cast(ability.type)
