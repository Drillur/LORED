class_name UnitVico
extends MarginContainer



onready var rt = get_node("/root/Root")
onready var healing_event: MarginContainer
onready var attributes: VBoxContainer = $"%attributes"
onready var health: Panel = $"%health"
onready var blood: Panel = $"%blood"
onready var icon: Panel = $"%icon"
onready var _name: Label = $"%name"
onready var target_border: Panel = $"%target_border"
onready var main_target: Panel = $"%spell_main_target_border"
onready var buffs_parent: VBoxContainer = $"%buffs"

var unit: Unit

var buff_vicos := {}



func _ready() -> void:
	healing_event = get_owner()
	hide_main_target_border()
	buffs_parent.hide()
	gv.connect("unit_status_effect_applied", self, "add_status_effect_vico")



func _on_Button_mouse_entered() -> void:
	healing_event.target_unit(self)
	rt.get_node("global_tip")._call("tooltip/Unit", {"unit": unit})


func _on_Button_mouse_exited() -> void:
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont.unassign_vicos()
	rt.get_node("global_tip")._call("no")



func setup(_unit: Unit):
	
	unit = _unit
	unit.assign_vico(self)
	
	icon.set_icon(unit.sprite)
	_name.text = unit.name
	health.setup(AttributeVico.Type.HEALTH, unit.health)
	blood.setup(AttributeVico.Type.BLOOD, unit.blood)
	
	show()



func target():
	target_border.show()


func untarget():
	target_border.hide()



func reset():
	target_border.hide()
	hide()
	unit = null



func show_main_target_border() -> void:
	main_target.show()


func hide_main_target_border() -> void:
	main_target.hide()



func process_status_effect(buff: UnitStatusEffect) -> void:
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		t.start(buff.tick_duration.get_as_float())
		yield(t, "timeout")
		if buff.marked_for_removal:
			break
		
		buff.tick()
		
		if buff.marked_for_removal:
			break
	
	t.queue_free()
	unit.remove_buff(buff)



func add_status_effect_vico(_unit: Unit, buff: UnitStatusEffect) -> void:
	if unit != _unit:
		return
	var buff_vico = gv.SRC["UnitStatusEffectWheel"].instance()
	buff_vico.setup(buff)
	buffs_parent.add_child(buff_vico)
	buff_vicos[buff.type] = buff_vico
	buffs_parent.show()
