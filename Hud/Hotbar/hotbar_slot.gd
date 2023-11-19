class_name HotbarSlot
extends MarginContainer



@onready var background = %Background
@onready var icon = %Icon
@onready var cooldown = %Cooldown
@onready var cooldown_progress = %"Cooldown Progress"
@onready var cooldown_text = %"Cooldown Text"
@onready var button = %Button
@onready var hotkey = %Hotkey
@onready var control = $Control

signal hotkey_pressed(ability)
signal display_tooltip(ability)

var ability: UnitAbility:
	set(val):
		if has_ability():
			remove_ability()
		ability = val
		button.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		if ability.has_cooldown():
			ability.cooldown.active.changed.connect(cooldown_changed)
		ability.unit.cooldown.active.changed.connect(cooldown_changed)
		ability.currency_gained.connect(ability_currency_gained)
		hotkey.show()
		cooldown_changed()

var input_action: String:
	set(val):
		if input_action != val:
			input_action = val
			var input_events = InputMap.action_get_events(input_action)
			for input_event in input_events:
				if input_event is InputEventKey:
					var keycode = input_event.physical_keycode
					var keycode_string = OS.get_keycode_string(keycode)
					hotkey.text = "[i]" + keycode_string



func _ready():
	set_process(false)
	input_action = "HotbarSlot" + str(get_index() + 1)
	hotkey.hide()
	cooldown.hide()
	button.mouse_exited.connect(gv.clear_tooltip)



# - Internal


func remove_ability() -> void:
	set_process(false)
	cooldown.hide()
	button.mouse_default_cursor_shape = CURSOR_ARROW
	ability.cooldown.active.changed.disconnect(cooldown_changed)
	ability.unit.cooldown.active.changed.disconnect(cooldown_changed)
	ability.currency_gained.disconnect(ability_currency_gained)
	hotkey.hide()
	ability = null


func throw_error_text(_text: String, _color: Color) -> void:
	gv.flash(self, _color)
	var text = FlyingText.new(
		FlyingText.Type.JUST_TEXT,
		control,
		gv.texts_parent,
		[0, 0],
	)
	text.add({
		"color": _color,
		"text": _text,
	})
	text.go()




# - Signal


func _process(_delta):
	var progress: float
	var text: String
	if ability.has_cooldown() and ability.cooldown.get_time_left() > ability.unit.cooldown.get_time_left():
		progress = 100 - (ability.cooldown.get_progress() * 100)
		text = ability.cooldown.get_time_left_text()
	else:
		progress = 100 - (ability.unit.cooldown.get_progress() * 100)
		text = ability.unit.cooldown.get_time_left_text()
	cooldown_progress.value = progress
	cooldown_text.text = text


func _input(_event):
	if (
		Input.is_action_just_pressed(input_action)
		and can_cast()
	):
		hotkey_pressed.emit(ability)


func _on_button_pressed():
	if can_cast():
		hotkey_pressed.emit(ability)


func _on_button_mouse_entered():
	if has_ability():
		display_tooltip.emit(ability)


func cooldown_changed() -> void:
	if ability.unit.cooldown.is_active() or (ability.has_cooldown() and ability.cooldown.is_active()):
		set_process(true)
		cooldown.show()
	else:
		cooldown.hide()
		set_process(false)
		gv.flash(self, Color.GREEN)


func ability_currency_gained(cur: Currency.Type, amount) -> void:
	match ability.type:
		UnitAbility.Type.PICK_FLOWER, UnitAbility.Type.SIFT_SEEDS:
			var text = FlyingText.new(
				FlyingText.Type.CURRENCY,
				control,
				control,
				[0, 0],
			)
			text.add({
				"cur": int(cur),
				"text": "+" + str(amount),
				"crit": false,
			})
			text.go()



# - Action


func setup(_ability: UnitAbility) -> void:
	ability = _ability
	icon.texture = ability.details.icon



# - Get


func can_cast() -> bool:
	if ability == null:
		throw_error_text("No ability assigned!", Color.RED)
		return false
	if not ability.unit.can_cast():
		if not ability.unit.is_alive():
			throw_error_text("Unit is dead.", Color.RED)
		elif ability.unit.cooldown.is_active():
			throw_error_text("On cooldown.", Color.RED)
		elif ability.unit.is_casting():
			throw_error_text("Already casting.", Color.RED)
		return false
	if not ability.can_cast():
		if ability.cost.affordable.is_false():
			throw_error_text("Cannot afford.", Color.RED)
		elif ability.cooldown.is_active():
			throw_error_text("On cooldown.", Color.RED)
		return false
	return true


func has_ability() -> bool:
	return ability != null
