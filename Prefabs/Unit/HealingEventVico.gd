class_name HealingEventVico
extends MarginContainer



enum Mode {
	IDLE,
	ACTIVE,
}
enum Status {
	ACTIVE,
	INACTIVE
}

onready var border: Panel = $"%border"
onready var mode_text: Label = $"%mode text"
onready var mode_button_text: Label = $"%mode button text"
onready var hotbar: MarginContainer = $"%Hotbar"

var mode: int = Mode.IDLE
var status: int = Status.INACTIVE

var healing_event: HealingEvent

var targeting_something := false
var target_vico: UnitVico
var unit_vicos: Array
var lored = lv.lored[lv.Type.BLOOD]




func _ready() -> void:
	
	if get_owner().name != "BLOOD":
		queue_free()
		return
	
	hotbar.setup()
	setup_unit_vicos()
	
	border.self_modulate = gv.COLORS["MANA"]
	reset_units()


func setup_unit_vicos() -> void:
	for i in range(1, 4):
		var unit_vico = get_node("%Unit" + str(i)) as UnitVico
		unit_vico.blood.make_small()
		unit_vicos.append(unit_vico)



func _input(event) -> void:
	if mode == Mode.IDLE:
		return
	
	if event.is_class("InputEventMouseMotion"):
		return
	
	if Input.is_key_pressed(KEY_ESCAPE):
		if lored.is_casting():
			lored.interrupt_and_cancel_cast()
		return
	
	if Input.is_key_pressed(KEY_1):
		hotbar.cast_ability_by_hotkey(KEY_1, target_vico)
		return
	
	if Input.is_key_pressed(KEY_2):
		hotbar.cast_ability_by_hotkey(KEY_2, target_vico)
		return
	
	if Input.is_key_pressed(KEY_3):
		hotbar.cast_ability_by_hotkey(KEY_3, target_vico)
		return
	
	if Input.is_key_pressed(KEY_4):
		hotbar.cast_ability_by_hotkey(KEY_4, target_vico)
		return
	
	if Input.is_key_pressed(KEY_R):
		hotbar.cast_ability_by_hotkey(KEY_R, target_vico)
		return
	
	if Input.is_key_pressed(KEY_F):
		hotbar.cast_ability_by_hotkey(KEY_F, target_vico)
		return
	
	if Input.is_key_pressed(KEY_TAB):
		if not targeting_something:
			target_unit(unit_vicos[0])
			return
		
		var unit_count = healing_event.unit_count
		if target_vico == unit_vicos[0]:
			target_unit(unit_vicos[1])
		elif target_vico == unit_vicos[1]:
			target_unit(unit_vicos[2 if unit_count == 3 else 0])
		else:
			target_unit(unit_vicos[0])
		
		return


func _on_Button_pressed() -> void:
	swap_mode()



func new_healing_event(_type: int) -> void:
	healing_event = HealingEvent.new(_type)
	setup_units()
	status = Status.ACTIVE


func setup_units() -> void:
	var units = healing_event.get_units()
	for i in range(1, 4):
		var unit_vico = unit_vicos[i - 1] as UnitVico
		if i > healing_event.unit_count:
			unit_vico.reset()
		else:
			unit_vico.setup(units[i - 1])
	for x in units.size():
		if not x in healing_event.starting_status_effects.keys():
			continue
		for buff_type in healing_event.starting_status_effects[x]:
			units[x].take_status_effect(buff_type)



func reset_units() -> void:
	for unit_vico in unit_vicos:
		unit_vico.reset()




func swap_mode() -> void:
	if mode == Mode.IDLE:
		set_mode(Mode.ACTIVE)
	else:
		set_mode(Mode.IDLE)


func set_mode(_mode: int) -> void:
	mode = _mode
	mode_text.text = "Mode: Idle" if mode == Mode.IDLE else "Mode: Active"
	mode_button_text.text = "Play" if mode == Mode.IDLE else "Stop"



func target_unit(unit_vico: UnitVico) -> void:
	if target_vico == unit_vico:
		return
	if unit_vico.unit.is_dead():
		return
	if mode == Mode.IDLE:
		return
	
	targeting_something = true
	target_vico = unit_vico
	unit_vico.target()
	untarget_other_units()


func untarget_all_units() -> void:
	target_vico = null
	targeting_something = false
	untarget_other_units()


func untarget_other_units() -> void:
	for unit_vico in unit_vicos:
		if unit_vico != target_vico:
			unit_vico.untarget()
