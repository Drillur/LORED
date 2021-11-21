extends MarginContainer


onready var bar_flair = get_node("cooldown/bar/flair")
onready var cooldown = get_node("cooldown")
onready var hotkey_text = get_node("hotkey/text")
onready var icon = get_node("m/icon/Sprite")


var spell := -1
var caster: Unit




func cast():
	
	var target = yield(Cav, "spell_target_confirmed")
	
	caster.cast(spell, target)

func setHotkeyText(_text: String):
	hotkey_text.text = _text

func _on_bar_value_changed(value: float) -> void:
	
	if value <= 0:
		cooldown.hide()
		return
	
	bar_flair.value = value + 1

func setSpell(type: int):
	spell = type
	setIcon()
func setIcon(type: int = spell):
	if type == -1:
		hideIconAndHotkey()
		return
	Cav.spell[type].getIcon()

func hideIconAndHotkey():
	icon.hide()
	hotkey_text.hide()


func _on_select_mouse_entered() -> void:
	if spell == -1:
		hotkey_text.show()

func _on_select_mouse_exited() -> void:
	if spell == -1:
		hotkey_text.hide()
