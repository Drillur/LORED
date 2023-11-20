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
@onready var tooltip_parent = %RightUp
@onready var cast_bar = %CastBar as Bar
@onready var cast_bar_container = %CastBarContainer
@onready var buff_container = %BuffContainer

var unit: Unit
var currency_0: Currency
var currency_1: Currency

var buffs := {}

var stored_mana_gain: float
var mana_timer := Timer.new()



func _ready() -> void:
	add_child(mana_timer)
	mana_timer.one_shot = true
	mana_timer.wait_time = 1.0
	mana_timer.timeout.connect(display_mana_gain)
	
	stamina_bar.color = UnitResource.get_color(UnitResource.Type.STAMINA)
	stamina_bar.label_name.text = "[color=#%s]%s[/color]" % [stamina_bar.color.to_html(), "Stamina"]
	mana_bar.color = UnitResource.get_color(UnitResource.Type.MANA)
	mana_bar.label_name.text = wa.get_currency(Currency.Type.MANA).details.color_text % "Mana"
	cast_bar_container.hide()
	for i in 12:
		var hotbar_slot: HotbarSlot = get("hotbar_slot_" + str(i))
		hotbar_slot.hotkey_pressed.connect(hotkey_pressed)
		hotbar_slot.display_tooltip.connect(display_ability_tooltip)



func setup(_unit: Unit) -> void:
	if has_unit():
		disconnect_currencies()
		stamina_bar.remove_value()
		mana_bar.remove_value()
		cast_bar.remove_timer()
		unit.started_casting.disconnect(unit_started_casting)
		unit.stopped_casting.disconnect(unit_finished_casting)
		unit.mana_gained.disconnect(unit_mana_gained)
		unit.received_buff.disconnect(unit_received_buff)
	unit = _unit
	connect_currencies()
	cast_bar.attach_timer(unit.cast_timer)
	cast_bar.set_process(false)
	cast_bar.color = unit.lored.details.color
	unit.started_casting.connect(unit_started_casting)
	unit.stopped_casting.connect(unit_finished_casting)
	unit.mana_gained.connect(unit_mana_gained)
	unit.received_buff.connect(unit_received_buff)
	
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


func _input(_event):
	if Input.is_action_just_pressed("ESC"):
		if has_unit() and unit.is_casting():
			unit.stop_casting()
			unit_finished_casting()
			return


func currency_0_changed() -> void:
	currency_0_text.text = "%s: %s" % [currency_0.details.get_icon_and_name(), currency_0.count.get_text()]


func currency_1_changed() -> void:
	currency_1_text.text = "%s: %s" % [currency_1.details.get_icon_and_name(), currency_1.count.get_text()]


func hotkey_pressed(ability: UnitAbility) -> void:
	ability.unit.cast(ability.type)


func display_ability_tooltip(ability: UnitAbility) -> void:
	gv.new_tooltip(gv.Tooltip.UNIT_ABILITY_TOOLTIP, tooltip_parent, {"ability": ability})


func unit_started_casting() -> void:
	cast_bar.set_process(true)
	var ability = unit.get_ability(unit.casting_ability)
	cast_bar.label.text = ability.details.colored_name
	gv.flash(cast_bar, ability.details.color)
	cast_bar_container.show()


func unit_finished_casting() -> void:
	cast_bar_container.hide()
	cast_bar.set_process(false)


func unit_mana_gained(amount: float) -> void:
	stored_mana_gain += amount
	if mana_timer.is_stopped():
		display_mana_gain()


func display_mana_gain() -> void:
	if stored_mana_gain >= 0.1:
		var text = FlyingText.new(
			FlyingText.Type.CURRENCY,
			currency_0_text,
			gv.texts_parent,
			[0, 0],
		)
		text.add({
			"cur": int(Currency.Type.MANA),
			"text": "+" + Big.get_float_text(stored_mana_gain),
			"crit": false,
		})
		text.go()
		stored_mana_gain = 0.0
		mana_timer.start()


func unit_received_buff(buff: UnitBuff) -> void:
	buffs[buff] = res.get_resource("buff_vico").instantiate()
	buff_container.add_child(buffs[buff])
	buffs[buff].setup(buff)



# - Get


func has_unit() -> bool:
	return unit != null



# - Debug

@onready var casting_ability = %casting_ability
@onready var queued_ability = %queued_ability

func update_shit() -> void:
	casting_ability.text = "Casting " + UnitAbility.Type.keys()[unit.casting_ability]
	queued_ability.text = "Queued: " + UnitAbility.Type.keys()[unit.queued_ability]
