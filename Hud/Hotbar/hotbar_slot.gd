class_name HotbarSlot
extends MarginContainer



@onready var background = %Background
@onready var icon = %Icon
@onready var cooldown = %Cooldown
@onready var cooldown_progress = %"Cooldown Progress"
@onready var cooldown_text = %"Cooldown Text"
@onready var button = %Button
@onready var hotkey = %Hotkey

signal hotkey_pressed(ability)

var ability: UnitAbility:
	set(val):
		if ability != null:
			remove_ability()
		button.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		ability = val
		hotkey.show()

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
	input_action = "HotbarSlot" + str(get_index() + 1)
	hotkey.hide()
	cooldown.hide()


func _input(event):
	if (
		Input.is_action_just_pressed(input_action)
		and ability != null
	):
		hotkey_pressed.emit(ability)



func setup(_ability: UnitAbility) -> void:
	ability = _ability
	icon.texture = ability.details.icon


func remove_ability() -> void:
	button.mouse_default_cursor_shape = CURSOR_ARROW
	ability = null


func _on_button_pressed():
	if ability != null:
		hotkey_pressed.emit(ability)
